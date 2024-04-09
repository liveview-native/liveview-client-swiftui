//
//  Attribute.swift
//  
//
//  Created by Carson Katri on 2/28/23.
//

import SwiftUI
import LiveViewNativeCore

/// A type that conforms to this protocol can be decoded from a DOM attribute key/value pair.
///
/// A number of implementations are included:
/// 1. `Optional`, when the `Wrapped` type conforms to `AttributeDecodable`
/// 2. `String`
/// 3. `Bool`
/// 4. `Double`
/// 4. `Int`
/// 5. `Date`
/// 6. Any `RawRepresentable` type with `String` raw values
/// 7. SwiftUI's `Color`
///
/// ## Topics
/// ### Initializers
/// - ``init(from:)-5yds5``
/// ### Supporting Types
/// - ``AttributeDecodingError``
public protocol AttributeDecodable {
    init(from attribute: LiveViewNativeCore.Attribute?) throws
    init(from attribute: LiveViewNativeCore.Attribute?, on element: ElementNode) throws
}

public extension AttributeDecodable {
    init(from attribute: LiveViewNativeCore.Attribute?) throws {
        fatalError("\(Self.self) cannot be decoded without an `element`")
    }
    
    init(from attribute: LiveViewNativeCore.Attribute?, on element: ElementNode) throws {
        try self.init(from: attribute)
    }
}

/// An error encountered when converting a value from an attribute.
public enum AttributeDecodingError: LocalizedError {
    /// The attribute was not present.
    case missingAttribute(Any.Type)
    /// The attribute had a value that couldn't be decoded.
    case badValue(Any.Type)
    
    public var errorDescription: String? {
        switch self {
        case let .missingAttribute(type):
            return "Value missing for attribute of type \(type)"
        case let .badValue(type):
            return "Invalid value for attribute of type \(type)"
        }
    }
}

/// Decodes an optional value (where the wrapped type is itself ``AttributeDecodable``) type from an attribute.
///
/// If the attribute is not provided, or the wrapped type could not be initialized from it, the result is `nil`.
extension Optional: AttributeDecodable where Wrapped: AttributeDecodable {
    public init(from attribute: LiveViewNativeCore.Attribute?, on element: ElementNode) throws {
        guard let attribute else {
            self = .none
            return
        }
        do {
            self = .some(try .init(from: attribute, on: element))
        } catch {
            guard attribute.value == nil else { throw error }
            self = .none
        }
    }
}

/// Decodes a string from an attribute, if the attribute is present.
extension String: AttributeDecodable {
    public init(from attribute: LiveViewNativeCore.Attribute?, on element: ElementNode) throws {
        guard let attribute else { throw AttributeDecodingError.missingAttribute(Self.self) }
        self = attribute.value ?? ""
    }
}

/// Decodes a boolean from an attribute.
/// The value is `true` if the attribute is present (regardless of value) and `false` otherwise.
extension Bool: AttributeDecodable {
    public init(from attribute: LiveViewNativeCore.Attribute?, on element: ElementNode) throws {
        self = attribute != nil && attribute?.value != "false"
    }
}

/// Decodes a double from an attribute, if it is present.
extension Double: AttributeDecodable {
    public init(from attribute: LiveViewNativeCore.Attribute?, on element: ElementNode) throws {
        guard let attributeValue = attribute?.value else { throw AttributeDecodingError.missingAttribute(Self.self) }
        guard let result = Self(attributeValue) else { throw AttributeDecodingError.badValue(Self.self) }
        self = result
    }
}

/// Decodes an integer from an attribute, if it is present.
extension Int: AttributeDecodable {
    public init(from attribute: LiveViewNativeCore.Attribute?, on element: ElementNode) throws {
        guard let attributeValue = attribute?.value else { throw AttributeDecodingError.missingAttribute(Self.self) }
        guard let result = Self(attributeValue) else { throw AttributeDecodingError.badValue(Self.self) }
        self = result
    }
}

/// Decodes a date from an attribute, if it is present.
/// The value is interpreted as an Elixir-style ISO 8601 date with an optional time component.
extension Date: AttributeDecodable {
    public init(from attribute: LiveViewNativeCore.Attribute?, on element: ElementNode) throws {
        guard let attributeValue = attribute?.value else { throw AttributeDecodingError.missingAttribute(Self.self) }
        self = try Self(attributeValue, strategy: .elixirDateTimeOrDate)
    }
}

/// Decodes any `String` raw representable type from an attribute, if it is present.
extension AttributeDecodable where Self: RawRepresentable, RawValue == String {
    public init(from attribute: LiveViewNativeCore.Attribute?, on element: ElementNode) throws {
        guard let attributeValue = attribute?.value else { throw AttributeDecodingError.missingAttribute(Self.self) }
        guard let value = Self(rawValue: attributeValue) else { throw AttributeDecodingError.badValue(Self.self) }
        self = value
    }
}

extension SwiftUI.Color: AttributeDecodable {
    public init(from attribute: LiveViewNativeCore.Attribute?, on element: ElementNode) throws {
        guard let attributeValue = attribute?.value else { throw AttributeDecodingError.missingAttribute(Self.self) }
        guard let value = SwiftUI.Color(fromNamedOrCSSHex: attributeValue) else { throw AttributeDecodingError.badValue(Self.self) }
        self = value
    }
}

extension CoreFoundation.CGFloat: AttributeDecodable {
    public init(from attribute: LiveViewNativeCore.Attribute?, on element: ElementNode) throws {
        self.init(try Double.init(from: attribute, on: element))
    }
}
