//
//  PulseConfig.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 6/8/24.
//

import Foundation
import Pulse

public enum PulseConfig {
    public static func set() {
        URLSessionProxyDelegate.enableAutomaticRegistration()
    }
}
