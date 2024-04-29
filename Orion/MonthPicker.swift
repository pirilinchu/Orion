//
//  MonthPicker.swift
//  Orion
//
//  Created by Santiago Mendoza on 1/4/24.
//

import SwiftUI

struct MonthPicker: View {
    @EnvironmentObject var appInfo: AppInfo

    var body: some View {
        VStack {
            Text("Elige el mes")
                .font(.title2)
                .foregroundStyle(Color.primaryText)
            Picker("Pick a month", selection: $appInfo.month) {
                ForEach(appInfo.monthOptions, id: \.self) { month in
                    Text(month.title).tag(month as? MyMonth)
                        .foregroundStyle(Color.primaryText)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .clipped()
        }
        .padding(16)
        .background(Color.secondaryBackground)
        .cornerRadius(16)
    }
}

#Preview {
    ZStack {
        Color.primaryBackground
        MonthPicker()
            .environmentObject(AppInfo())
            .padding(32)
    }
    .ignoresSafeArea()
}
