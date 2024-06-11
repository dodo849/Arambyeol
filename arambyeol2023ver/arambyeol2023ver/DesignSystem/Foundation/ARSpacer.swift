//
//  Spacer.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 6/11/24.
//

import SwiftUI

struct ARSpacer: View {
    var minW: CGFloat? = nil
    var minH: CGFloat? = nil
    var maxW: CGFloat? = nil
    var maxH: CGFloat? = nil

    var body: some View {
        Spacer()
            .frame(minWidth: minW, idealWidth: nil, maxWidth: maxW, minHeight: minH, idealHeight: nil, maxHeight: maxH)
    }
}

#Preview {
    Spacer()
}
