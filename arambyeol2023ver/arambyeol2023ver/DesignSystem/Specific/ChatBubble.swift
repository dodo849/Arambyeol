//
//  ChatBubble.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 6/11/24.
//

import SwiftUI

struct ChatBubbleView: View {
    private let CHAT_CORNER_RADIUS: CGFloat = 15
    
    var chat: ChatModel
    
    var body: some View {
        VStack(alignment: horizontalAlignment) {
                if !isMe {
                    Text(chat.nickname)
                        .font(.system(size: 13))
                        .foregroundStyle(.gray05)
                }
                HStack(alignment: .bottom) {
                    Text(chat.date, style: .time)
                        .font(.system(size: 12))
                        .foregroundStyle(.gray04)
                    Text(chat.message)
                        .font(.system(size: 14))
                        .multilineTextAlignment(isMe ? .leading : .trailing)
                        .foregroundStyle(.basicText)
                        .padding(12)
                        .background(bubbleColor)
                        .clipShape(
                            .rect(
                                topLeadingRadius: cornerRadii.0,
                                bottomLeadingRadius: cornerRadii.1,
                                bottomTrailingRadius: cornerRadii.2,
                                topTrailingRadius: cornerRadii.3
                            )
                        )
                }
                .environment(
                    \.layoutDirection,
                     isMe
                     ? .leftToRight
                     : .rightToLeft
                )
            }
            .frame(maxWidth: .infinity, alignment: alignment)
            .padding(.horizontal)
    }
    
    private var isMe: Bool {
        chat.author == .me
    }
    
    private var bubbleColor: Color {
        switch chat.author {
        case .me: return .chatYellow
        case .others: return .chatBlue
        }
    }

    private var alignment: Alignment {
        switch chat.author {
        case .me: return .trailing
        case .others: return .leading
        }
    }
    
    private var horizontalAlignment: HorizontalAlignment {
        switch chat.author {
        case .me: return .trailing
        case .others: return .leading
        }
    }

    private var cornerRadii: (CGFloat, CGFloat, CGFloat, CGFloat) {
        switch chat.author {
        case .me:
            return (CHAT_CORNER_RADIUS, CHAT_CORNER_RADIUS, 0, CHAT_CORNER_RADIUS)
        case .others:
            return (CHAT_CORNER_RADIUS, 0, CHAT_CORNER_RADIUS, CHAT_CORNER_RADIUS)
        }
    }
}
