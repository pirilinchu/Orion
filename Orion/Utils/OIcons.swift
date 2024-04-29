//
//  OIcons.swift
//  Orion
//
//  Created by Santiago Mendoza on 29/4/24.
//

import Foundation

enum OIcons: String {
    case plus = "plus.circle.fill"
    case minus = "minus.circle.fill"
    case repeatIcon = "repeat"

    var systemImage: String {
        self.rawValue
    }
}
