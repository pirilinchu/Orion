//
//  ContentView.swift
//  Orion
//
//  Created by Santiago Mendoza on 1/4/24.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        OrionView()
    }
}

#Preview {
    ContentView()
}

extension Color {
    init(hex: String) {
        var cleanHexCode = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        cleanHexCode = cleanHexCode.replacingOccurrences(of: "#", with: "")
        print(cleanHexCode)
        var rgb: UInt64 = 0

        Scanner(string: cleanHexCode).scanHexInt64(&rgb)

        let redValue = Double((rgb >> 16) & 0xFF) / 255.0
        let greenValue = Double((rgb >> 8) & 0xFF) / 255.0
        let blueValue = Double(rgb & 0xFF) / 255.0
        self.init(red: redValue, green: greenValue, blue: blueValue)
    }
}

extension Color {
    static let primaryBackground = Color(hex: "121212")
    static let secondaryBackground = Color(hex: "1E1E1E")
    static let primaryText = Color(hex: "FFFFFF")
    static let clandarBackground = Color(hex: "2D2D2F")
}
