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
                            Image(systemName: "minus.circle.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundStyle(Color.primaryText)
                        }
                    }
                }
            }
            if appInfo.people.count < 5 {
                HStack {
                    TextField("Escribe un nombre", text: $textField)
                        .frame(height: 24)
                        .foregroundStyle(Color.primaryText)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .padding(8)
                    Button {
                        if !textField.isEmpty && isValidName(textField) {
                            appInfo.people.append(Person(color: Color.userColors[appInfo.people.count], name: textField))
                            textField = ""
                                                }
                    } label: {
                        Image(systemName: "plus.circle.fill")
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
    
    func isValidName(_ name: String) -> Bool {
        let nameRegex = "[A-Za-z0-9 ]*"
        let namePredicate = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        return namePredicate.evaluate(with: name)
    }
}

#Preview {
    PeopleView()
        .environmentObject(AppInfo())
}

extension Color {
    static let user1 = Color(hex: "1E90FF")
    static let user2 = Color(hex: "32CD32")
    static let user3 = Color(hex: "FFA500")
    static let user4 = Color(hex: "800080")
    static let user5 = Color(hex: "FF0000")

    static let userColors = [user1, user2, user3, user4, user5]
}
