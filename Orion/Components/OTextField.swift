//
//  OTextField.swift
//  Orion
//
//  Created by Santiago Mendoza on 12/4/24.
//

import SwiftUI

struct OTextField: View {
    @Binding var text: String

    var body: some View {
        TextField("Escribe un nombre", text: $text)
            .frame(height: 24)
            .foregroundStyle(Color.primaryText)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 1)
            )
            .padding(8)
    }
}

#Preview {
    OTextField(text: .constant("test"))
        .background(Color.black)
}
