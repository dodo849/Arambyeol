//
//  ScrollOffset+Extension.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 6/8/24.
//

import SwiftUI

struct ScrollOffsetPreferenceKey: PreferenceKey {
    typealias Value = CGFloat

    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}


struct ScrollOffsetModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(GeometryReader {
                Color.clear.preference(
                    key: ScrollOffsetPreferenceKey.self,
                    value: $0.frame(in: .named("scrollView")).minY
                )
            })
    }
}

extension View {
    func trackScrollOffset() -> some View {
        self.modifier(ScrollOffsetModifier())
    }
}
