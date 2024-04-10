//
//  OrionView.swift
//  Orion
//
//  Created by Santiago Mendoza on 1/4/24.
//

import SwiftUI

struct OrionView: View {
    @StateObject var appInfo = AppInfo()

    var body: some View {
        VStack(spacing: 16) {
            switch appInfo.state {
            case .year:
                YearPicker()
                    .environmentObject(appInfo)
                    .padding(.horizontal, 32)
            case .month:
                MonthPicker()
                    .environmentObject(appInfo)
                    .padding(.horizontal, 32)
            case .people:
                PeopleView()
                    .environmentObject(appInfo)
                    .padding(.horizontal, 32)
            case .calendar:
                CalendarView()
                    .environmentObject(appInfo)
            }
            Button(action: {
                appInfo.onNextPressed()
            }) {
                Image(systemName: "arrow.forward")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundColor(.primaryBackground)
                    .font(.body)
                    .background(Color.primaryText)
                    .cornerRadius(100)
            }
            .padding(.horizontal, 32)

            if appInfo.state == .calendar {
                Button(action: {
                    appInfo.clearCalendar()
                }) {
                    Image(systemName: "repeat")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 50)
                        .foregroundColor(.primaryBackground)
                        .font(.body)
                        .background(Color.primaryText)
                        .cornerRadius(100)
                }
                .padding(.horizontal, 32)
            }
        }
        .frame(maxHeight: .infinity)
        .background(Color.primaryBackground)
    }
}

#Preview {
    OrionView()
}
