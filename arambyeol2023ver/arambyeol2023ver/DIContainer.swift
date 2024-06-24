//
//  DIContainer.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 6/19/24.
//

import Factory

extension Container {
    
    // MARK: - Usecase
    var chatUsecase: Factory<ChatUsecase> {
        Factory(self) { ChatUsecase() }
    }
    
    // MARK: - Service
    var chatService: Factory<ChatService> {
        Factory(self) { ChatService() }.singleton
    }
    
    var tokenService: Factory<TokenService> {
        Factory(self) { TokenService() }.singleton
    }
    
    // MARK: - Repository
    var tokenRepository: Factory<TokenRepository> {
        Factory(self) { TokenRepository.shared }.singleton
    }
    
    var deviceIDRepository: Factory<DeviceIDRepository> {
        Factory(self) { DeviceIDRepository.shared }.singleton
    }
    
    // MARK: - Converter
    var chatConverter: Factory<ChatConverter> {
        Factory(self) { DefaultChatConverter() }.singleton
    }
}
