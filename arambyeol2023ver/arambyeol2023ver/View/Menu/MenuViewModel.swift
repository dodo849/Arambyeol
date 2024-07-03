//
//  MenuViewModel.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 7/3/24.
//

import SwiftUI
import Combine

import Factory

final class MenuViewModel: ObservableObject {
    // MARK: Input Action
    enum Action {
        case onAppear
        case none
    }
    
    @Subject var action: Action = .none
    
    // MARK: Output State
    @Published var menu: MenuModel = .empty
    @Published var hoursOfOperation: HoursOfOperation = .empty
    @Published var currentMealTime: MealTime = .morning
    
    // MARK: Private data
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: Dependendcy
    @Injected(\.menuUsecase) private var menuUsecase
    
    init() {
        bind()
    }
    
    private func bind() {
        $action
            .withUnretained(self)
            .sink { (owner, action) in
                switch action {
                case .onAppear:
                    Task {
                        await owner.fetchMenu()
                    }
                    
                    let hours = owner.menuUsecase.getHoursOfOperation()
                    let mealTime = owner.menuUsecase.getCurrentMealTime()
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.hoursOfOperation = hours
                        self?.currentMealTime = mealTime
                    }
                default: break
                }
            }
            .store(in: &cancellables)
    }
    
    private func fetchMenu() async {
        do {
            let fetchedMenu = try await menuUsecase.fetchMenu()
            DispatchQueue.main.async { [weak self] in
                self?.menu = fetchedMenu
            }
        } catch {
            print(error)
        }
    }
}
