//
//  ChatReportView.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 6/11/24.
//

import SwiftUI

struct ChatReportView: View {
    @State private var selectedReportType: ChatReportDTO.ContentType? = .harmful
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ARText("신고하기", size: 18, weight: .bold)
                .padding(.bottom, 10)
            
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
            
            Button(action: {
                // 제출하기 버튼 클릭 시 수행할 작업
                print("Report submitted: \(selectedReportType?.rawValue ?? "")")
            }) {
                ARText("제출하기", weight: .semibold, color: .arYellow)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.arYellowSoft)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
        .padding(.horizontal, 15)
    }
}

#Preview {
    ChatReportView()
}
