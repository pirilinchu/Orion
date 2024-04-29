//
//  String-Extension.swift
//  Orion
//
//  Created by Santiago Mendoza on 29/4/24.
//

import Foundation

extension String {
    func isValidName() -> Bool {
        let nameRegex = "[A-Za-z0-9 ]*"
        let namePredicate = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        return namePredicate.evaluate(with: self)
    }
}
