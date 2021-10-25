//
//  RaisedButtonStyle.swift
//  XPLRR
//
//  Created by Dylan Elliott on 5/10/21.
//

import SwiftUI

struct RaisedButtonStyle: ButtonStyle {

    let depth: CGFloat
    let color: Color
    
    init(depth: CGFloat = 1, color: Color = .blue) {
        self.depth = depth
        self.color = color
    }

    func makeBody(configuration: Configuration) -> some View {
        let currentDepth = configuration.isPressed ? 0 : depth
        return configuration.label
            .offset(x: 0, y: -currentDepth/1.5)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                Rectangle().fill(Color.secondary)
                    .frame(height: 40)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8).fill(color)
                    .offset(x: 0, y: -currentDepth)
                )
            )
    }
}
