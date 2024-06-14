//
//  ChatReportView.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 6/11/24.
//

import SwiftUI

struct ChatReportSheet: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var chat: ChatModel?
    @State private var selectedReportType: ChatReportDTO.ContentType? = .harmful
    
    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            Text("⚠️ 채팅 신고하기")
                .font(.system(size: 18, weight: .bold))
            Text("신고할 내용: \(chat?.message ?? "오류")")
                .font(.system(size: 14))
                .foregroundColor(.gray05)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(10)
                .background(.gray02)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            RadioGroup(
                defaultValue: ChatReportDTO.ContentType.allCases.first!,
                onChange: { _ in }
            ) {
                ForEach(ChatReportDTO.ContentType.allCases, id: \.self) { option in
                    RadioOption(value: option) {
                        Text(option.description)
                    }
                    .styled(shape: .circle)
                }
            }
            
            Spacer()
            
            Text("*신고된 내용은 관리자 검토후 처리됩니다")
                .font(.system(size: 13))
                .foregroundColor(Color.gray.opacity(0.4))
            Button(action: {
                Task {
                    await report()
                    dismiss()
                }
            }) {
                Text("제출하기")
            }
            .styled()
        }
        .padding(.horizontal, 25)
        .padding(.vertical, 30)
        .background(.basicBackground)
    }
    
    private func report() async {
        guard let chat = chat else { return }
        do {
            let result = try await ChatService.reportChat(
                reporterDid: DeviceIDManager.shared.getID(),
                chatId: chat.id,
                content: selectedReportType ?? .harmful
            )
            print("report result: \(result)")
        } catch {
            print("report error: \(error)")
        }
    }
}
