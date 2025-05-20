//
//  MockUserDefaults.swift
//  StonksTests
//
//  Created by Michael Moore on 5/19/25.
//

import Foundation
@testable import Stonks

class MockUserDefaults: UserDefaults {
    var storage: [String: Any] = [:]
    
    override func set(_ value: Any?, forKey defaultName: String) {
        storage[defaultName] = value
    }
    
    override func object(forKey defaultName: String) -> Any? {
        return storage[defaultName]
    }
    
    override func stringArray(forKey defaultName: String) -> [String]? {
        return storage[defaultName] as? [String]
    }
    
    override func removeObject(forKey defaultName: String) {
        storage.removeValue(forKey: defaultName)
    }
}