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
    @State var refresable: Refreshable = .init()
    @State var isRefreshing: Bool = false
    @State var firstItemBeforeLoading: UUID = .init()
    
    @State var messages: [Message] = (0..<100).map { Message(text: String($0)) }
    
    func addMore() async {
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        DispatchQueue.main.async {
            (1...30).forEach { i in
                    messages.insert(.init(text: "new message \(i)"), at: 0)
            }
        }
    }
    
    var body: some View {
        VStack {
            // chat layer
            ScrollViewReader { scrollProxy in
                ScrollView {
                    GeometryReader { geometry in
                        DispatchQueue.main.async {
                            refresable.scrollOffset = geometry.frame(in: .named(namespace)).minY
                            print(refresable.scrollOffset)
                            print(refresable.state)
                            
                            if refresable.state == .none
                                && refresable.scrollOffset > 40
                            {
                                refresable.state = .pending
                            }
                            
                            if refresable.state == .pending && refresable.scrollOffset > 120 && !isRefreshing {
                                isRefreshing = true
                                refresable.state = .loading
                                firstItemBeforeLoading = messages.first!.id
                                Task {
                                    await addMore()
                                    DispatchQueue.main.async {
                                        refresable.state = .none
                                        isRefreshing = false
                                        scrollProxy.scrollTo(firstItemBeforeLoading, anchor: .top)
                                    }
                                }
                            }
                        }
                        
                        return Color.clear
                    }
                    
                    LazyVStack {
                        ForEach(messages, id: \.self) { message in
                            Text("\(message.text)")
                                .id(message.id)
                        }
                    }
                    .background(Color.gray02)
                }
                .padding(.horizontal)
                .padding(.top, isRefreshing ? refresable.scrollOffset <= 31 ? 30 : 0 : 0)
                .animation(.easeInOut, value: refresable.state)
                .frame(maxWidth: .infinity, minHeight: 100)
                .overlay {
                    VStack {
                        Image(systemName: "arrow.up")
//                            .rotationEffect(Angle(degrees: refresable.scrollOffset))
                            .foregroundStyle(.black)
                            .opacity(refresable.state.indicatorOpacity)
                            .animation(.linear, value: refresable.state)
                            .offset(y: refresable.scrollOffset * 0.3)
                        Spacer()
                    }
                }
                .offset(y: -GEOMETRY_HEIGHT) // Transparent geometry reader height
                
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
                        messages.append(.init(text: text))
                        text.removeAll()
                        
                        Task {
                            await MainActor.run {
                                withAnimation {
                                    scrollProxy.scrollTo(messages.last!.id, anchor: .top)
                                }
                            }
                        }
                    }) {
                        Image("chat-send-icon")
                    }
                    
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(.white)
                }
            }
        }
        .customBackButton { dismiss() }
        .addHideKeyboardGuesture()
    }
    
}

