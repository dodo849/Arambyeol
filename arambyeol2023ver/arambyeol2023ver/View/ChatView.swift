//
//  ChatView.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 6/4/24.
//

import SwiftUI

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
                TextField("", text: $text)
                Button("보내기") {
                    client.send(
                        topic: "/pub/chat",
                        body: .string(text)) { error in
                            if let error = error {
                                print("실패!!!")
                            }
                            text = ""
                        }
                    
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
                case .success(let body):
                    print("받았당: \(body)")
                    switch body {
                    case .string(let text):
                        messages.append(text)
                    @unknown default:
                        break
                    }
                }
            }
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
