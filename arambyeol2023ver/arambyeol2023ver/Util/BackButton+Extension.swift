//
//  BackButton+Extension.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 6/8/24.
//

import SwiftUI
import UIKit

extension View {
    func customBackButton(dismissAction: @escaping () -> Void) -> some View {
        return self.navigationBarBackButtonHidden(true)
            .navigationBarItems(
                leading: Button(action: {
                    dismissAction()
                }) {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(.black)
                }
            )
    }
}

extension UINavigationController: ObservableObject, UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
