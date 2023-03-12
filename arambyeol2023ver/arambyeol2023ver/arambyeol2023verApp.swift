//
//  arambyeol2023verApp.swift
//  arambyeol2023ver
//
//  Created by 김가은 on 2023/03/06.
//

import SwiftUI

@main
struct arambyeol2023verApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainView()
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
