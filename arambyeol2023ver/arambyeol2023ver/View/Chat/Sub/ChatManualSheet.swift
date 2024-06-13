//
//  ChatManualSheet.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 6/11/24.
//

import SwiftUI

struct ChatManualSheet: View {
    var body: some View {
        VStack {
            Text(
            """
            채팅 말풍선을 길게 누르면 신고할 수 있습니다.
            신고된 채팅은 관리자 검토 후 처리됩니다.
            신고 누적 시 이용이 정지될 수 있습니다.
            """)
            .fixedSize(horizontal: false, vertical: true)
            Spacer()
        }
        .frameMax([.width], alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.vertical, 30)
    }
}

#Preview {
    ChatManualSheet()
}
