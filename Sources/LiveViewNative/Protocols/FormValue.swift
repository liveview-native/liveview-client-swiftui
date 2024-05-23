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
/// A number of out-of-the-box `FormValue` implementations are provided:
/// 1. `Optional`, when the `Wrapped` type itself conforms to `FormValue`
/// 2. `String`
/// 3. `Bool`
/// 4. `Double`
/// 5. `Date`
public protocol FormValue: Equatable, Codable {
    func formQueryEncoded() throws -> String
}

private let formQueryEncoder = JSONEncoder()
public extension FormValue {
    func formQueryEncoded() throws -> String {
        String(data: try formQueryEncoder.encode(self), encoding: .utf8)!
    }
}

extension FormValue {
    func isEqual<T>(to other: T) -> Bool {
        guard let other = other as? Self else {
            return false
        }
        return self == other
    }
    
    static func fromAttribute(_ attribute: LiveViewNativeCore.Attribute, on element: ElementNode) -> Self? {
        if let self = Self.self as? AttributeDecodable.Type {
            return try? (self.init(from: attribute, on: element) as! Self)
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
