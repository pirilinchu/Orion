//
//  PeopleView.swift
//  Orion
//
//  Created by Santiago Mendoza on 1/4/24.
//

import SwiftUI

struct PeopleView: View {
    @EnvironmentObject var appInfo: AppInfo

    @State var textField: String = ""

    var body: some View {
        VStack(spacing: 2) {
            Text("Agrega personas")
                .font(.title2)
                .foregroundStyle(Color.primaryText)
                .padding(.bottom, 20)
            VStack(spacing: 2) {
                ForEach(appInfo.people) { person in
                    HStack {
                        HStack {
                            Text(person.name)
                                .frame(height: 24)
                            Spacer()
                        }
                        .foregroundStyle(Color.primaryText)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .padding(8)
                        Button {
                            appInfo.people.removeAll(where: { $0.id == person.id })
                        } label: {
                            Image(systemName: OIcons.minus.systemImage)
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundStyle(Color.primaryText)
                        }
                    }
                }
            }
            if appInfo.people.count < 5 {
                HStack {
                    OTextField(text: $textField)
                    Button {
                        if !textField.isEmpty, textField.isValidName() {
                            appInfo.people.append(Person(color: Color.userColors[appInfo.people.count], name: textField))
                            textField = ""
                                                }
                    } label: {
                        Image(systemName: OIcons.plus.systemImage)
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(Color.primaryText)
                    }
                }
            }
        }
        .padding(16)
        .background(Color.secondaryBackground)
        .cornerRadius(16)
    }
    
    
}

#Preview {
    PeopleView()
        .environmentObject(AppInfo())
}
