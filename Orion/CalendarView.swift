//
//  CalendarView.swift
//  Orion
//
//  Created by Santiago Mendoza on 1/4/24.
//

import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var appInfo: AppInfo
    @State private var isEditingName = false
    let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7)
    let columnsDay: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 1), count: 2)
    let week: [String] = ["D", "L", "M", "M", "J", "V", "S"]

    var body: some View {
        VStack(spacing: 4) {
            VStack(alignment: .leading, spacing: 4) {
                ForEach(appInfo.people) { person in
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
                                peop
                            }) {
                                Image(systemName: "pencil.line")
                                    .resizable()
                                    .frame(width: 20, height: 20)
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
                .sheet(isPresented: $isEditingName) {
                    PeopleView()
                        .environmentObject(appInfo)
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
        .padding(4)
    }
}

#Preview {
    ZStack {
        Color.primaryBackground
            .ignoresSafeArea()
        CalendarView()
            .environmentObject(AppInfo())
    }
}
