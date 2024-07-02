//
//  Navigation+Extension.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 7/3/24.
//

import SwiftUI

struct NavigationBarModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithTransparentBackground()
                appearance.shadowColor = .clear
                
                UINavigationBar.appearance().standardAppearance = appearance
                UINavigationBar.appearance().scrollEdgeAppearance = appearance
            }
    }
}

extension View {
    func customNavigationBar() -> some View {
        self.modifier(NavigationBarModifier())
    }
}
