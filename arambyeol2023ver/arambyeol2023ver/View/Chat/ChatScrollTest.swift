//
//  ChatScrollTest.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 6/9/24.
//

import SwiftUI
import Combine

struct ChatScrollTest: View {
    let GEOMETRY_HEIGHT: CGFloat = 10
    
    struct Message: Hashable {
        let id: UUID = .init()
        let text: String
    }
    private var CHAT_CORNER_RADIUS: CGFloat = 25
    
    @Environment(\.dismiss) var dismiss
    @Namespace private var namespace
    
    @State var text: String = ""
//    @State var refresable: Refreshable = .init()
    @State var isRefreshing: Bool = false
    @State var focusMessageID: UUID = .init()
    
    @State var messages: [Message] = (0..<50).map { Message(text: String($0)) }
    
    func addMore() async {
        try? await Task.sleep(nanoseconds: 1_000_000_000 / 10)
        DispatchQueue.main.async {
            if let lastMessage = messages.last?.text {
                let newMessages = (Int(lastMessage)!+1...Int(lastMessage)!+30).map { i in
                    Message(text: String(i))
                }
                messages.append(contentsOf: newMessages)
            }
        }
    }
    
    var body: some View {
        VStack {
            // chat layer
            RefreshableView(reverse: true) {
                LazyVStack {
                    ForEach(messages.reversed(), id: \.self) { message in
                        Text("\(message.text)")
                            .id(message.id)
                    }
                }
            } indicator: {
                Image (systemName: "arrow.up")
                    .foregroundColor(.white)
                    .padding(5)
                    .background(.black)
                    .cornerRadius(15)
                    .asIndicator()
            } onRefresh: {
                await addMore()
            }
            .background(Color.gray02)
            
            // text field layer
            HStack {
                TextField("텍스트를 입력해주세요", text: $text)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 15)
                    .background(.gray01)
                    .padding(.bottom, 1)
                
                Button(action: {
                    if text.isEmpty { return }
                    messages.append(.init(text: text))
                    text.removeAll()
                    
                    Task {
                        await MainActor.run {
                            withAnimation {
                                //                                scrollProxy.scrollTo(messages.last!.id, anchor: .top)
                            }
                        }
                    }
                }) {
                    Text("보내기")
                }
                
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(.white)
            }
        }
        .customBackButton { dismiss() }
        .addHideKeyboardGuesture()
        
    }

}
