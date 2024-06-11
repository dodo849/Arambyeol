//
//  Text.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 6/11/24.
//

import SwiftUI

struct ARText: View {
    var text: String
    var size: Int
    var weight: Font.Weight
    var color: Color
    
    init(_ text: String, size: Int = 16, weight: Font.Weight = .regular, color: Color = .arText) {
        self.text = text
        self.size = size
        self.weight = weight
        self.color = color
    }

    var body: some View {
        Text(text)
            .font(.system(size: CGFloat(size), weight: weight))
            .foregroundColor(color)
    }
}
