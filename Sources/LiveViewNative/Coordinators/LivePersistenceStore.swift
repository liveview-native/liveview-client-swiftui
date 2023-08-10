//
//  LivePersistenceStore.swift
//
//
//  Created by Carson Katri on 8/10/23.
//

import SwiftUI

/// A type that handles persistence.
///
/// Use the functions `push_persistent_value` and `load_persistent_value` to store/retrieve values from the client.
public protocol LivePersistenceStore {
    func setValue(_ value: Any, forKey key: String, options: [String:Any]) throws
    func loadValue(forKey key: String, options: [String:Any]) throws -> Any?
}

/// A persistence store that uses `UserDefaults`.
///
/// Options:
/// - `suite_name`: Use a custom suite. Defaults to the standard suite if not provided.
public struct UserDefaultsPersistenceStore: LivePersistenceStore {
    public init() {}
    
    private static func makeDefaults(withOptions options: [String:Any]) -> UserDefaults {
        if let suiteName = options["suite_name"] as? String {
            return .init(suiteName: suiteName) ?? .standard
        } else {
            return .standard
        }
    }
    
    public func setValue(_ value: Any, forKey key: String, options: [String : Any]) throws {
        Self.makeDefaults(withOptions: options).setValue(value, forKey: key)
    }
    
    public func loadValue(forKey key: String, options: [String : Any]) throws -> Any? {
        Self.makeDefaults(withOptions: options).value(forKey: key)
    }
}

public extension LivePersistenceStore where Self == UserDefaultsPersistenceStore {
    static var userDefaults: UserDefaultsPersistenceStore { .init() }
}
