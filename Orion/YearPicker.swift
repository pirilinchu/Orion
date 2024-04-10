//
//  YearPicker.swift
//  Orion
//
//  Created by Santiago Mendoza on 1/4/24.
//

import SwiftUI

struct YearPicker: View {
    @EnvironmentObject var appInfo: AppInfo
    
    var body: some View {
        VStack {
            Text("Elige el año")
                .font(.title2)
                .foregroundStyle(Color.primaryText)
            Picker("Pick a year", selection: $appInfo.year) {
                ForEach(appInfo.yearOptions, id: \.self) { year in
                    Text(String(year)).tag(year as? Int)
                        .foregroundStyle(Color.primaryText)
                }
            }
            .pickerStyle(WheelPickerStyle()) // Use a wheel style picker
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
        YearPicker()
            .environmentObject(AppInfo())
            .padding(32)
    }
    .ignoresSafeArea()
}
