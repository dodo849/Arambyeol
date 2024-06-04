//
//  ChatView.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 6/4/24.
//

import SwiftUI

struct ChatRequest: Codable {
    let message: String
}

struct ChatView: View {
    
    @State var text: String = ""
    @State var messages: [String] = []
    
    private let client = StompClient(url: URL(string: "wss://aramchat.kro.kr:443/ws-stomp")!)
    
    var body: some View {
        VStack {
            // chat layer
            ScrollView {
                ForEach(messages, id: \.self) {
                    Text($0)
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
                
                Button(action: { sendChat(text) }) {
                    Image("chat-send-icon")
                }
                
            }
        }
        .padding()
        .onAppear {
            client.connect() { error in
                if error != nil {
                    print("실패!!! \(error)")
                }
            }
            client.subscribe(topic: "/sub/ArambyeolChat") { result in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let data):
                    let messageResult = try? data.decode(ChatRequest.self)
                    messages.append(messageResult?.message ?? "")
                }
            }
        }
    }
    
    func sendChat(_ text: String) {
        client.send(
            topic: "/pub/chat",
            body: .json(ChatRequest(message: text))) { error in
                if let error = error {
                    print("실패!!!")
                }
                self.text = ""
            }
        
    }
}

#Preview {
    ChatView()
}

//let webSocketURL = URL(string: "wss://aramchat.kro.kr:443/ws-stomp")!
//let client = StompClient(url: webSocketURL)
//Button("연결") {
//    client.connect() { error in
//        if error != nil {
//            print("실패!!! \(error)")
//        }
//    }
//    client.subscribe(topic: "/sub/ArambyeolChat") { result in
//        switch result {
//        case .failure(let error):
//            print(error)
//        case .success(let body):
//            print("받았당: \(body)")
//        }
//    }
//}
//
//Button("보내기") {
//    client.send(
//        topic: "/pub/chat",
//        body: .string("안녕하세용용")) { error in
//            if let error = error {
//                print("실패!!!")
//            }
//        }
//}
