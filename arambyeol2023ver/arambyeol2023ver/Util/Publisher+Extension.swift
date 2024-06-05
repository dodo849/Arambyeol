//
//  Publisher+Extension.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 6/5/24.
//

import Combine

extension Publisher {
  func withUnretained<O: AnyObject>(_ owner: O) -> Publishers.CompactMap<Self, (O, Self.Output)> {
    compactMap { [weak owner] output in
      owner == nil ? nil : (owner!, output)
    }
  }
}
