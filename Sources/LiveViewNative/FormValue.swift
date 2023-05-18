//
//  FormValue.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 2/17/23.
//

import Foundation
import LiveViewNativeCore

/// A form value is any type that can be stored in a ``FormModel`` and used with ``FormState``.
///
/// The `Codable` representation is used for sending form events and when a live binding is used.
/// See ``FormState`` for more information about how form values and live bindings interact.
///
/// A number of out-of-the-box `FormValue` implementations are provided:
/// 1. `Optional`, when the `Wrapped` type itself conforms to `FormValue`
/// 2. `String`
/// 3. `Bool`
/// 4. `Double`
/// 5. `Date`
public protocol FormValue: Equatable, Codable {
}

extension FormValue {
    func isEqual<T>(to other: T) -> Bool {
        guard let other = other as? Self else {
            return false
        }
        return self == other
    }
    
    static func fromAttribute(_ attribute: LiveViewNativeCore.Attribute) -> Self? {
        if let self = Self.self as? AttributeDecodable.Type {
            return try? (self.init(from: attribute) as! Self)
        } else {
            return nil
        }
    }
}

extension Optional: FormValue where Wrapped: FormValue {
}

extension Set: FormValue where Element: FormValue {
}

extension String: FormValue {
}

extension Bool: FormValue {
}

extension Double: FormValue {
}

extension Date: FormValue {
}
