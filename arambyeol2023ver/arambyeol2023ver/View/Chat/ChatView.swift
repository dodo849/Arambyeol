//
//  ChatView.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 6/4/24.
//

import SwiftUI
import Combine



struct ChatView: View {
    private var CHAT_CORNER_RADIUS: CGFloat = 25
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ChatViewModel
    
    @State var text: String = ""
    @State var firstIdBeforeLoading: String = ""
    
    init(viewModel: ChatViewModel = ChatViewModel()) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // chat layer
            ScrollViewReader { scrollProxy in
                RefreshableView(reverse: true) {
                    LazyVStack {
                        ForEach(viewModel.messages.reversed(), id: \.self) { message in
                            chatBox(for: message)
                                .id(message.id)
                        }
                    }
                } onRefresh: {
                    try? await Task.sleep(nanoseconds: 1_000_000_000)
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
                    
                    Button(action: {
                        if text.isEmpty { return }
                        viewModel.$action.send(.sendMessage(text))
                        text.removeAll()
                        
                        Task { // 이미 메인 액터 컨텍스트인데 왜 감싸줘야하는지 잘 모르겠음
                            await MainActor.run {
                                withAnimation {
                                    if let firstID = viewModel.messages.first?.id {
                                        scrollProxy.scrollTo(firstID, anchor: .bottom)
                                    }
                                }
                                
                            }
                        }
                    }) {
                        Image("chat-send-icon")
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
                .background(.white)
            }
        }
        .customBackButton { dismiss() }
        .navigationTitle("💬 채팅")
        .addHideKeyboardGuesture()
        .onAppear {
            viewModel.$action.send(.onAppear)
        }
        .onDisappear {
            viewModel.$action.send(.onDisappear)
        }
    }
    
    @ViewBuilder
    private func chatBox(for chat: ChatViewModel.ChatModel) -> some View {
        switch chat.author {
        case .me:
            Group {
                HStack(alignment: .bottom) {
                    Text(chat.date, style: .time)
                        .font(.system(size: 12))
                        .foregroundStyle(.gray04)
                    Text(chat.message)
                        .font(.system(size: 14))
                        .padding(12)
                        .background(.chatYellow)
                        .clipShape(
                            .rect(
                                topLeadingRadius: CHAT_CORNER_RADIUS,
                                bottomLeadingRadius: CHAT_CORNER_RADIUS,
                                bottomTrailingRadius: 0,
                                topTrailingRadius: 0
                            )
                        )
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.horizontal)
        case .others:
            Group {
                Text(chat.nickname)
                    .font(.system(size: 13))
                    .foregroundStyle(.gray05)
                HStack(alignment: .bottom) {
                    Text(chat.message)
                        .font(.system(size: 14))
                        .padding(12)
                        .background(.chatBlue)
                        .clipShape(
                            .rect(
                                topLeadingRadius: 0,
                                bottomLeadingRadius: 0,
                                bottomTrailingRadius: CHAT_CORNER_RADIUS,
                                topTrailingRadius: CHAT_CORNER_RADIUS
                            )
                        )
                    Text(chat.date, style: .time)
                        .font(.system(size: 12))
                        .foregroundStyle(.gray04)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
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
