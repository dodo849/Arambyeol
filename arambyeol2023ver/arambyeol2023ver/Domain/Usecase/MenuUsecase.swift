//
//  MenuUsecase.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 7/3/24.
//

import OSLog

import Factory

final class MenuUsecase {
    @Injected(\.menuService) private var menuService: MenuService
    
    let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: "MenuUsecase"
    )
    
    func fetchMenu() async throws -> MenuModel {
        do {
            let menu = try await menuService.fetchMenu()
            return menu
        } catch {
            throw MenuError.failedFetchMenu(error)
        }
    }
}
