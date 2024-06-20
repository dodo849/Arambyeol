//
//  ChatView.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 6/4/24.
//

import SwiftUI
import Combine



struct ChatView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: ChatViewModel = ChatViewModel()
    @State var text: String = ""
    @State var isReportSheetOpen: Bool = false
    @State var reportChat: ChatModel?
    @State var isManualSheetOpen: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            // chat layer
            ScrollViewReader { scrollProxy in
                RefreshableView(reverse: true) {
                    LazyVStack(spacing: 18) {
                        ForEach(viewModel.chatCells.reversed(), id: \.id) { chatCell in
                            switch chatCell {
                            case .message(let chat):
                                ChatBubbleView(chat: chat)
                                    .id(chatCell.id)
                                    .onTapGesture { hideKeyboard() }
                                    .onLongPressGesture(minimumDuration: 0.5) {
                                        reportChat = chat
                                        isReportSheetOpen = true
                                    }
                            case .date(let date):
                                Text(date, style: .date)
                                    .id(chatCell.id)
                            }
                        }
                    }
                } onRefresh: {
                    // for refresable indicator animation
                    try? await Task.sleep(nanoseconds: 1_000_000_000 / 2)
                    await viewModel.fetchPreviousChat()
                }
                
                // text field layer
                HStack {
                    TextField("텍스트를 입력해주세요", text: $text)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 15)
                        .background(.gray01)
                        .cornerRadius(25)
                        .overlay {
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.gray02, lineWidth: 1)
                        }
                    
                    Button {
                        if text.isEmpty { return }
                        viewModel.$action.send(.sendMessage(text))
                        text.removeAll()
                        
                        Task {
                            await MainActor.run {
                                withAnimation {
                                    if let firstID = viewModel.chatCells.first?.id {
                                        scrollProxy.scrollTo(firstID, anchor: .bottom)
                                    }
                                }
                            }
                        }
                    } label: {
                        Image("chat-send-icon")
                            .renderingMode(.template)
                    }
                    .styled(
                        variant: .transparent,
                        size: .xsmall
                    )
                    .disabled(text.isEmpty)
                    .animation(.spring(duration: 0.2), value: text.isEmpty)
                    .padding(0)
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
                .background(.basicBackground)
            }
        }
        .customBackButton { dismiss() }
        .navigationTitle("💬 채팅")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { isManualSheetOpen = true }) {
                    HStack {
                        Image(systemName: "exclamationmark.circle")
                            .foregroundStyle(.gray04)
                    }
                }
            }
        }
        .addHideKeyboardGuesture()
        .onAppear {
            viewModel.$action.send(.onAppear)
        }
        .onDisappear {
            viewModel.$action.send(.onDisappear)
        }
        .sheet(isPresented: $isReportSheetOpen) {
            ChatReportSheet(chat: $reportChat)
                .presentationDetents([.height(500), .large])
        }.sheet(isPresented: $isManualSheetOpen) {
            ChatManualSheet()
                .presentationDetents([.fraction(0.2)])
        }
    }
}

#Preview {
    ChatView(
        viewModel: ChatViewModel(
            messages: [
                .init(
                    id: UUID().uuidString,
                    did: UUID().uuidString,
                    message: "안녕하세요!!",
                    nickname: "춤추는 낙타",
                    author: .me,
                    date: Date.now
                ),
                .init(
                    id: UUID().uuidString,
                    did: UUID().uuidString,
                    message: "맛있었으면 좋겠다.",
                    nickname: "따뜻한 알로에",
                    author: .others,
                    date: Date.now
                )
            ]
        )
    )
}
