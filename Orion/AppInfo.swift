//
//  AppInfo.swift
//  Orion
//
//  Created by Santiago Mendoza on 1/4/24.
//

import SwiftUI

final class AppInfo: ObservableObject {
    @Published var month: MyMonth?
    @Published var year: Int?
    @Published var daysArray: [MyDay] = []
    @Published var people: [Person] = []

    @Published var state: AppState = .year

    let monthOptions: [MyMonth]
    let yearOptions: [Int]

    var activePeople: [Person] {
        people.filter({ $0.isOn })
    }

    init() {
        let date = Date()
        let calendar = Calendar.current
        self.month = MyMonth(rawValue: calendar.component(.month, from: date))
        let year = calendar.component(.year, from: date)
        self.year = year
        self.monthOptions = MyMonth.allCases
        self.yearOptions = [year, year + 1]
//        populateDays()
    }
    
    func onBackPressed() {
        switch state {
        case .year:
            break
        case .month:
            state = .year
        case .people:
            state = .month
        case .calendar:
            state = .people
        }
    }

    func onNextPressed() {
        switch state {
        case .year:
            state = .month
        case .month:
            state = .people
        case .people:
            populateDays()
        case .calendar:
            break
        }
    }
    
    func clearCalendar() {
        for i in 0..<daysArray.count {
            daysArray[i].people = []
        }
        for i in 0..<people.count {
            people[i].isOn = false
        }
    }

    func populateDays() {
        for _ in 0..<42 {
            daysArray.append(MyDay(id: -1, body: ""))
        }

        let calendar = Calendar.current

        guard let year, let month else {
            return
        }
        
        let components = DateComponents(year: year, month: month.rawValue, day: 1)

        guard let firstDay = calendar.date(from: components), let daysCount = calendar.range(of: .day, in: .month, for: firstDay)?.count else {
            return
        }

        let weekday = calendar.component(.weekday, from: firstDay)

        for i in (weekday - 1)..<(daysCount+weekday-1) {
            daysArray[i] = MyDay(id: i - weekday + 2, body: "")
        }

        if daysArray[35].id == -1 {
            daysArray = daysArray.dropLast(7)
        }
        state = .calendar
    }

    func edit(person: Person?) {
        // Prevent duplicated names
        guard let person, people.first(where: { $0.name == person.name }) == nil else {
            return
        }

        guard let index = people.firstIndex(where: { $0.id == person.id }) else {
            return
        }

        people[index] = person
    }

    func exportToCSV(filename: String) -> URL {
        var csvString = "Día,Paciente(s)\n" // Header row
        for day in daysArray {
            let dayString = "\(day.id),"
//            let peopleString = day.people.map { $0.name }.joined(separator: "|")
            let rowString = "\(dayString)\(/*peopleString*/dayString)\n"
            csvString.append(rowString)
        }

        let fileURL = URL(fileURLWithPath: filename)
        do {
            try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
            print("CSV file exported successfully: \(fileURL.path)")
        } catch {
            print("Error exporting CSV file: \(error)")
        }
        return fileURL
    }
}

struct MyDay: Identifiable {
    let id: Int
    let body: String
    var people: [Person] = []
}

struct Person: Identifiable {
    let id = UUID()
    let color: Color
    var name: String
    var isOn: Bool = false
}

enum AppState {
    case year
    case month
    case people
    case calendar
}

enum MyMonth: Int, CaseIterable {
    case january = 1
    case february
    case march
    case april
    case may
    case june
    case july
    case august
    case september
    case october
    case november
    case december

    var title: String {
        switch self {
            case .january:
                return "Enero"
            case .february:
                return "Febrero"
            case .march:
                return "Marzo"
            case .april:
                return "Abril"
            case .may:
                return "Mayo"
            case .june:
                return "Junio"
            case .july:
                return "Julio"
            case .august:
                return "Agosto"
            case .september:
                return "Septiembre"
            case .october:
                return "Octubre"
            case .november:
                return "Noviembre"
            case .december:
                return "Diciembre"
        }
    }
}

extension String {
    var short: String {
        let words = self.components(separatedBy: " ")
        let firstLetters = words.prefix(2).compactMap { $0.first }
        return String(firstLetters)
    }
}
