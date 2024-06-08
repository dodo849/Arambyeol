//
//  ChatView.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 6/4/24.
//

import SwiftUI

struct ChatView: View {
    private var CHAT_CORNER_RADIUS: CGFloat = 25
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ChatViewModel
    
    @State var text: String = ""
    @State var scrollOffset: CGPoint = .init(x: 0, y: 0)
    
    init(viewModel: ChatViewModel = ChatViewModel()) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            // chat layer
            ScrollViewReader{ scrollProxy in
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.messages, id: \.self) { message in
                            chatBox(for: message)
                                .id(message.id)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 100)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .refreshable {
                    await viewModel.fetchPreviousChat()
                    print(scrollProxy)
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
                                    if let targetMessageId = viewModel.messages.last?.id {
                                        scrollProxy.scrollTo(targetMessageId, anchor: .top)
                                    }
                                }
                            }
                        }
                    }) {
                        Image("chat-send-icon")
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
            }
        }
        .customBackButton { dismiss() }
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
                        .font(.system(size: 16))
                        .padding()
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
        case .others:
            Group {
                Text(chat.nickname)
                    .font(.system(size: 13))
                    .foregroundStyle(.gray05)
                HStack(alignment: .bottom) {
                    Text(chat.message)
                        .font(.system(size: 16))
                        .padding()
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
