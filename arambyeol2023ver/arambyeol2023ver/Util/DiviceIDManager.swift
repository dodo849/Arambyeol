//
//  UUIDManager.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 6/5/24.
//

import Foundation
import UIKit

class DiviceIDManager {
    
    static let shared = DiviceIDManager()
    
    private let uuidKey = "com.arambyeol.uuid"
    
    private init() {
        // Private initialization to ensure just one instance is created.
    }
    
    func getID() -> String {
        if let storedID = UserDefaults.standard.string(forKey: uuidKey) {
            return storedID
        } else {
            let newID = generateID()
            UserDefaults.standard.set(newID, forKey: uuidKey)
            return newID
        }
    }
    
    private func generateID() -> String {
        if let vendorID = UIDevice.current.identifierForVendor?.uuidString {
            return vendorID
        } else {
            return UUID().uuidString
        }
    }
}
