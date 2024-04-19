//
//  CalendarView.swift
//  Orion
//
//  Created by Santiago Mendoza on 1/4/24.
//

import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var appInfo: AppInfo
    
    @State private var isEditing = false
    @State private var currentPerson: Person? = nil
    @State private var text: String = ""
    @State private var renderedImage: Image?
    let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7)
    let columnsDay: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 1), count: 2)
    let week: [String] = ["D", "L", "M", "M", "J", "V", "S"]
    
    var body: some View {
        VStack(spacing: 4) {
            Spacer()
            VStack(alignment: .leading, spacing: 4) {
                ForEach(appInfo.people) { person in
                    PersonButton(person: person)
                }
            }
            HStack(spacing: 4) {
                ForEach(Array(week.enumerated()), id: \.offset) { index, item in
                    ZStack {
                        Color.clear
                        Text(item)
                            .foregroundStyle(Color.primaryText)
                            .font(.footnote)
                    }
                }
            }
            .frame(height: 50)
            CalendarGrid()
            Spacer()
            HStack {
//                Button("Render Image") {
//                    let renderer = ImageRenderer(content: CalendarGrid())
//                    renderer.scale = 3
//                    if let image = renderer.cgImage {
//                        renderedImage = Image(decorative: image, scale: 1.0)
//                    }
//                }
//                .buttonStyle(.borderedProminent)
                RenderedImageView(renderedImage: $renderedImage)
                    .navigationTitle("Calendar")
                if let renderedImage {
                    ShareLink(item: renderedImage, preview: SharePreview(Text("Shared Calendar"), image: renderedImage)) {
                    Label("", systemImage: "square.and.arrow.up")
                        .foregroundColor(.white)
                    }
                    .padding()
                }
            }
        }
        .overlay {
            if isEditing {
                ZStack {
                    Color.black.opacity(0.01)
                        .ignoresSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                edit()
                            }
                        }
                    HStack {
                        OTextField(text: $text)
                        Button {
                            edit()
                        } label: {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundStyle(Color.primaryText)
                        }
                    }
                    .padding(16)
                    .background(Color.secondaryBackground)
                    .cornerRadius(16)
                    .padding(16)
                }
                .onAppear {
                    text = currentPerson?.name ?? ""
                }
            }
        }
        .padding(4)
    }
    
//    private func exportImage() {
//        // 1. Create a UIHostingController with the CalendarView itself
//        let controller = UIHostingController(rootView: CalendarGrid())
//        controller.view.bounds = CGRect(x: 0, y: 0, width: 500, height: 500) // Specify the size you want
//
//        // 2. Begin image context
//        let renderer = UIGraphicsImageRenderer(bounds: controller.view.bounds)
//
//        // 3. Render the image
//        let image = renderer.image { _ in
//            controller.view.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
//        }
//
//        // 4. Update the renderedImage state for sharing
//        renderedImage = Image(uiImage: image)
//    }
    
    private func edit() {
        withAnimation {
            currentPerson?.name = text
            appInfo.edit(person: currentPerson)
            isEditing = false
        }
    }
}

private extension CalendarView {
    @ViewBuilder
    func CalendarGrid() -> some View {
        LazyVGrid(columns: columns, spacing: 4) {
            ForEach(appInfo.daysArray) { day in
                if day.id != -1 {
                    Button {
                        if let index = appInfo.daysArray.firstIndex(where: { $0.id == day.id }) {
                            appInfo.activePeople.forEach { person in
                                if !day.people.contains(where: { $0.id == person.id }) {
                                    appInfo.daysArray[index].people.append(person)
                                }
                            }
                        }
                    } label: {
                        ZStack {
                            Color.clandarBackground
                                .aspectRatio(contentMode: .fill)
                                .cornerRadius(4)
                            Text("\(day.id)")
                                .font(.body)
                                .foregroundStyle(Color.primaryText)
                                .opacity(0.1)
                            if !day.people.isEmpty {
                                LazyVGrid(columns: columnsDay, spacing: 1) {
                                    // Limiting to maximum 4 people
                                    ForEach(day.people.prefix(4)) { person in
                                        ZStack {
                                            Circle()
                                                .fill()
                                                .foregroundStyle(person.color.opacity(0.3))
                                            Text(person.name.short)
                                                .font(.footnote)
                                                .foregroundStyle(person.color)
                                        }
                                    }
                                    if day.people.count < 4 {
                                        let additionalCirclesCount = 4 - day.people.count
                                        ForEach(0..<additionalCirclesCount) { _ in
                                            Circle()
                                                .fill()
                                                .foregroundStyle(Color.clear)
                                        }
                                    }
                                }
                                .padding(2)
                                
                            }
                        }
                    }
                    .simultaneousGesture(LongPressGesture(minimumDuration: 1).onEnded { _ in
                        guard !day.people.isEmpty else {
                            return
                        }
                        if let index = appInfo.daysArray.firstIndex(where: { $0.id == day.id }) {
                            for i in 0..<appInfo.people.count {
                                appInfo.people[i].isOn = false
                            }
                            appInfo.daysArray[index].people = []
                        }
                    })
                } else {
                    Color.clear
                }
            }
        }
    }
    
    @ViewBuilder
    func PersonButton(person: Person) -> some View {
        Button {
            if let index = appInfo.people.firstIndex(where: { $0.id == person.id }) {
                appInfo.people[index].isOn.toggle()
            }
            
        } label: {
            HStack {
                ZStack {
                    Circle()
                        .fill()
                        .frame(width: 35, height: 35)
                        .foregroundStyle(person.color.opacity(0.3))
                    Text(person.name.short)
                        .font(.body)
                        .foregroundStyle(person.color)
                }
                Text(person.name)
                    .foregroundStyle(Color.primaryText)
                Spacer()
                Button(action: {
                    currentPerson = person
                    withAnimation {
                        isEditing = true
                    }
                }) {
                    Image(systemName: "pencil")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundColor(.white)
                }
            }
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .background {
                if person.isOn {
                    Color.secondaryBackground.cornerRadius(8)
                }
            }
        }
    }
}

#Preview {
    ZStack {
        let appInfo = AppInfo()
        Color.primaryBackground
            .ignoresSafeArea()
        CalendarView()
            .environmentObject(appInfo)
            .task {
                appInfo.month = .april
                appInfo.year = 2020
                appInfo.state = .calendar
                appInfo.populateDays()
                appInfo.people = [
                    Person(color: Color.user1, name: "test 1"),
                    Person(color: Color.user1, name: "test 2")
                ]
            }
    }
}
