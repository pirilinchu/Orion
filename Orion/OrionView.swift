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
            
            HStack {
                if appInfo.state == .calendar {
                    BackButton
                }
                else if appInfo.state == .year {
                    ForwardButton
                } else {
                    BackButton
                    ForwardButton
                }
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
                Spacer()
                HStack {
                    ShareButton
                    Spacer()
                }
            }
        }
        .frame(maxHeight: .infinity)
        .background(Color.primaryBackground)
        .onChange(of: appInfo.state) { newState in
            if newState == .year {
                appInfo.month = .january
                appInfo.people = []
                appInfo.clearCalendar()
            }
        }
    }
        
    // BUTTONS
    // Backward button view
    private var BackButton: some View {
        Button(action: {
            appInfo.onBackPressed()
        }) {
            Image(systemName: "arrow.backward")
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(height: 50)
                .foregroundColor(.primaryBackground)
                .font(.body)
                .background(Color.primaryText)
                .cornerRadius(100)
        }
        .padding(.horizontal, 5)
    }

    // Forward button view
    private var ForwardButton: some View {
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
        .padding(.horizontal, 5)
        .disabled(appInfo.state == .people && appInfo.people.isEmpty) 
    }
    
    // Share-Export button view
    private var ShareButton: some View {
        Button(action: {
            let shareURL = URL(string: "https://apps.apple.com/us/app/orion/id6447198696")!
            let activityViewController = UIActivityViewController(activityItems: [shareURL], applicationActivities: nil)
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController?.present(activityViewController, animated: true, completion: nil)
            }

        }) {
            Label("", systemImage: "square.and.arrow.up")
                .foregroundColor(.white)
        }
        .padding()
    }

}

#Preview {
    OrionView()
}
