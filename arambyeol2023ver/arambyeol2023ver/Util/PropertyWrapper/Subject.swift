//
//  Subject.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 6/5/24.
//

import Foundation
import Combine

@propertyWrapper
struct Subject<Value> {
    private var subject: PassthroughSubject<Value, Never>
    private var value: Value
    
    init(wrappedValue: Value) {
        self.value = wrappedValue
        self.subject = PassthroughSubject<Value, Never>()
    }

    var wrappedValue: Value {
        get { value }
        set {
            value = newValue
            subject.send(newValue)
        }
    }
    
    var projectedValue: PassthroughSubject<Value, Never> {
        return self.subject
    }
    
    func send(_ event: Value) {
        self.subject.send(event)
    }
}
