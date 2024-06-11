//
//  ChatReportView.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 6/11/24.
//

import SwiftUI

struct ChatReportView: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var chat: ChatViewModel.ChatModel?
    @State private var selectedReportType: ChatReportDTO.ContentType? = .harmful
    
    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            ARText("신고하기", size: 18, weight: .bold)
            ARText(
                "신고할 메세지 내용: \(chat?.message ?? "오류")",
                size: 14,
                color: .gray05
            )
            .padding()
            .frameMax([.width], alignment: .leading)
            .lineLimit(3)
            .background(.gray02)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            ForEach(ChatReportDTO.ContentType.allCases) { reportType in
                HStack {
                    Image(systemName: selectedReportType == reportType
                          ? "circle.inset.filled"
                          : "circle"
                    )
                    .foregroundStyle(
                        selectedReportType == reportType
                        ? .arYellow
                        : .gray04
                    )
                    .onTapGesture {
                        selectedReportType = reportType
                    }
                    ARText(reportType.description)
                }
            }
            
            Spacer()
            
            ARText("*신고된 내용은 관리자 검토후 처리됩니다", size: 13, color: .gray04)
            Button(action: {
                Task {
                    await report()
                    dismiss()
                }
            }) {
                ARText("제출하기", weight: .semibold, color: .arYellow)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.arYellowSoft)
                    .cornerRadius(10)
            }
        }
        .padding(.horizontal, 25)
        .padding(.vertical, 30)
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
