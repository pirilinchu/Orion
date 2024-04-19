//
//  RenderedImageView.swift
//  Orion
//
//  Created by Mateo Mercado Maguiña on 18/4/24.
//

import SwiftUI

struct RenderedImageView: View {
    @Binding var renderedImage: Image?
    var body: some View {
        if let renderedImage {
            renderedImage
                .resizable()
                .scaledToFit()
                .frame(width: 325)
        } else {
            Image(systemName: "photo.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 275, height: 275)
                .foregroundColor(.accentColor)
        }
    }
}

#Preview {
    RenderedImageView(renderedImage: .constant(nil))
}
