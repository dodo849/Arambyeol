//
//  ChatView.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 6/4/24.
//

import SwiftUI

struct ChatView: View {
    
    @ObservedObject var viewModel = ChatViewModel()
    @State var text: String = ""
    
    var body: some View {
        VStack {
            // chat layer
            ScrollView {
                ForEach(viewModel.messages, id: \.self) { item in
                    Text(item.message)
                }
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
                    viewModel.$sendMessage.send(text)
                    text.removeAll()
                }) {
                    Image("chat-send-icon")
                }
            }
        }
        .padding()
        .onAppear {
            viewModel.$onAppear.send(())
        }
    }
}

#Preview {
    ChatView()
}
