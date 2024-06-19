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
        Container.shared.tokenService.resolve().login()
        
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
                .onAppear {
                    PulseConfig.set()
                }
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
