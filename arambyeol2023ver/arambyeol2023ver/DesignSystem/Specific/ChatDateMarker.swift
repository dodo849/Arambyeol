//
//  ChatDateMarker.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 6/24/24.
//

import SwiftUI

struct ChatDateMarker: View {
    let date: Date
    
    var body: some View {
        HStack {
            Spacer()
            Text(date, style: .date)
                .typo(.body3)
                .foregroundColor(.gray)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(.gray01)
                .clipShape(Capsule())
            Spacer()
        }
    }
}
