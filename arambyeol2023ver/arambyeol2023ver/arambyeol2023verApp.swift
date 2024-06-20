//
//  arambyeol2023verApp.swift
//  arambyeol2023ver
//
//  Created by 김가은 on 2023/03/06.
//

import SwiftUI
import GoogleMobileAds
import AppTrackingTransparency

import Factory

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Setup token
        // TODO: 토큰 잇으면 Login X
//        if Container.shared.tokenRepository.resolve().getAccessToken().isEmpty {
            Task {
                let loginResult = await Container.shared.tokenService.resolve().login()
                print("### a \(Container.shared.tokenRepository.resolve().getAccessToken())")
                print("### b \(Container.shared.tokenRepository.resolve().getRefreshToken())")
                switch loginResult {
                case .success(): break
                case .failure(_):
                    let _ = await Container.shared.tokenService.resolve().signup()
                }
//            }
        }
        
        // Setup network console
        PulseConfig.set()
        
        return true
    }
}

@main
struct arambyeol2023verApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainView()
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
//    init() {
//        GADMobileAds.sharedInstance().start(completionHandler: nil)
//
//        // DispatchQueue 이용
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//          ATTrackingManager.requestTrackingAuthorization(completionHandler: { _ in })
//        }
//      }
}
