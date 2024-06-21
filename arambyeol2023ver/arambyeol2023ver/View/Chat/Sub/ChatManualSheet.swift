//
//  ChatManualSheet.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 6/11/24.
//

import SwiftUI

struct ChatManualSheet: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("📢 이용 안내")
                .font(.system(size: 18, weight: .bold))
            
            Text(
            """
            채팅 말풍선을 길게 누르면 신고할 수 있습니다.
            신고된 채팅은 관리자 검토 후 처리됩니다.
            신고 누적 시 이용이 정지될 수 있습니다.
            """)
            .frameMax([.width], alignment: .leading)
            .fixedSize(horizontal: false, vertical: true)
            .font(.system(size: 14, weight: .regular))
            .foregroundStyle(.gray06)
            .padding()
            .background(.gray01)
            .cornerRadius(15)
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                Text("확인")
            }.styled(variant: .translucent, color: .secondary)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 30)
    }
}

#Preview {
    ChatManualSheet()
}
