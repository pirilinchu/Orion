import SwiftUI

struct OrionView: View {
    @StateObject var appInfo = AppInfo()
    
    var body: some View {
        NavigationView {
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
            .navigationBarItems(leading: backButton)
            .navigationBarTitle("", displayMode: .inline)
        }
    }
    
    var backButton: some View {
        if appInfo.state != .year {
            return AnyView (
                Button(action: {
                    appInfo.onBackPressed()
                }) {
                    Image(systemName: "arrow.backward")
                        .foregroundColor(.primaryText)
                }
            )
        } else {
            return AnyView(EmptyView())
        }
    }
}

#Preview {
    OrionView()
}
