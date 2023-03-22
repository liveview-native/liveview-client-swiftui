//
//  Attribute.swift
//  
//
//  Created by Carson Katri on 2/28/23.
//

import SwiftUI
import LiveViewNativeCore

/// A property wrapper that decodes an attribute of an element.
///
/// Specify the attribute name and an optional default value. Then use the value in the body of the View.
/// ```swift
/// struct MyElement: View {
///     @Attribute("count") private var count: Double = 0
///
///     var body: some View {
///         Text("Count: \(count)")
///     }
/// }
/// ```
///
/// If the value is not optional and no default is provided, a fatal error will be thrown when the attribute is not present or fails to decode.
///
/// An attribute can also be created with a `transform` function, which can be used to convert a value that does not conform to ``AttributeDecodable`` or modify the way a value is decoded.
/// ```swift
/// @Attribute(
///     "count",
///     // add 5 to the count
///     transform: { $0?.value.flatMap(Double.init(_:)).flatMap({ $0 + 5 }) }
/// ) private var count: Double
/// ```
///
/// ## Topics
/// ### Initializers
/// - ``init(wrappedValue:_:)``
/// - ``init(wrappedValue:_:transform:)``
/// ### Getting the Value
/// - ``wrappedValue``
/// ### Supporting Types
/// - ``AttributeDecodable``
@propertyWrapper
public struct Attribute<T>: DynamicProperty {
    @ObservedElement private var element
    private let name: AttributeName
    private let defaultValue: T?
    private let transform: (LiveViewNativeCore.Attribute?) throws -> T

    /// Create an `Attribute` with an ``AttributeDecodable`` type.
    public init(wrappedValue: T? = nil, _ name: AttributeName) where T: AttributeDecodable {
        self.name = name
        self.defaultValue = wrappedValue
        self.transform = { try T(from: $0) }
    }
    
    /// Create an `Attribute` with a `transform` function that converts the attribute into the desired type.
    public init(wrappedValue: T? = nil, _ name: AttributeName, transform: @escaping (LiveViewNativeCore.Attribute?) throws -> T) {
        self.name = name
        self.defaultValue = wrappedValue
        self.transform = transform
    }

    /// Gets the decoded value of the attribute.
    ///
    /// If attribute decoding fails, this will return the default value the property wrapper was constructed with.
    /// If no default value was provided, the app will crash.
    public var wrappedValue: T {
        do {
            return try transform(element.attribute(named: name))
        } catch {
            guard let defaultValue else { fatalError(error.localizedDescription) }
            return defaultValue
        }
    }
}

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
///
/// ## Topics
/// ### Initializers
/// - ``init(from:)-5yds5``
/// ### Supporting Types
/// - ``AttributeDecodingError``
public protocol AttributeDecodable {
    init(from attribute: LiveViewNativeCore.Attribute?) throws
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
    public init(from attribute: LiveViewNativeCore.Attribute?) throws {
        guard let attribute else {
            self = .none
            return
        }
        do {
            self = .some(try .init(from: attribute))
        } catch {
            guard attribute.value == nil else { throw error }
            self = .none
        }
    }
}

/// Decodes a string from an attribute, if the attribute is present.
extension String: AttributeDecodable {
    public init(from attribute: LiveViewNativeCore.Attribute?) throws {
        guard let attributeValue = attribute?.value else { throw AttributeDecodingError.missingAttribute(Self.self) }
        self = attributeValue
    }
}

/// Decodes a boolean from an attribute.
/// The value is `true` if the attribute is present (regardless of value) and `false` otherwise.
extension Bool: AttributeDecodable {
    public init(from attribute: LiveViewNativeCore.Attribute?) throws {
        self = attribute != nil
    }
}

/// Decodes a double from an attribute, if it is present.
extension Double: AttributeDecodable {
    public init(from attribute: LiveViewNativeCore.Attribute?) throws {
        guard let attributeValue = attribute?.value else { throw AttributeDecodingError.missingAttribute(Self.self) }
        guard let result = Self(attributeValue) else { throw AttributeDecodingError.badValue(Self.self) }
        self = result
    }
}

/// Decodes an integer from an attribute, if it is present.
extension Int: AttributeDecodable {
    public init(from attribute: LiveViewNativeCore.Attribute?) throws {
        guard let attributeValue = attribute?.value else { throw AttributeDecodingError.missingAttribute(Self.self) }
        guard let result = Self(attributeValue) else { throw AttributeDecodingError.badValue(Self.self) }
        self = result
    }
}

/// Decodes a date from an attribute, if it is present.
/// The value is interpreted as an Elixir-style ISO 8601 date with an optional time component.
extension Date: AttributeDecodable {
    public init(from attribute: LiveViewNativeCore.Attribute?) throws {
        guard let attributeValue = attribute?.value else { throw AttributeDecodingError.missingAttribute(Self.self) }
        self = try Self(attributeValue, strategy: .elixirDateTimeOrDate)
    }
}

/// Decodes any `String` raw representable type from an attribute, if it is present.
extension AttributeDecodable where Self: RawRepresentable, RawValue == String {
    public init(from attribute: LiveViewNativeCore.Attribute?) throws {
        guard let attributeValue = attribute?.value else { throw AttributeDecodingError.missingAttribute(Self.self) }
        guard let value = Self(rawValue: attributeValue) else { throw AttributeDecodingError.badValue(Self.self) }
        self = value
    }
}
