//
//  ChatUsecase.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 6/14/24.
//

import Foundation
import OSLog

import Factory

struct ChatUsecase {
    @Injected(\.chatService) var chatService
    @Injected(\.chatConverter) var chatConverter
    
    let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: "ChatUsecase"
    )
    
    func fetchPreviousChat(startDate: Date) async -> [ChatType] {
        do {
            let fetchedChats = try await chatService.fetchPreviousChat(
                start: startDate,
                size: 25,
                page: 1
            )
            
            let convertedChats = fetchedChats.map {
                chatConverter.convertToChatModel(from: $0)
            }
            
            let chatTypes = convertedChats.map { ChatType.message($0) }
            let chatWithDates = insertDateMarkers(into: chatTypes)
            
            return chatWithDates
            
        } catch {
            logger.error("Fetch chat error: \(error)")
        }
        
        return [] // error
    }
}

extension ChatUsecase {
    private func insertDateMarkers(into chats: [ChatType]) -> [ChatType] {
        var result: [ChatType] = []
        var previousDate: Date?
        
        chats.forEach { chat in
            if case let .message(chatModel) = chat {
                let currentDate = Calendar.current.startOfDay(for: chatModel.date)
                if currentDate != previousDate {
                    if let previousDate = previousDate {
                        result.append(.date(previousDate))
                    }
                    previousDate = currentDate
                }
            }
            result.append(chat)
        }
        
        return result
    }
}
