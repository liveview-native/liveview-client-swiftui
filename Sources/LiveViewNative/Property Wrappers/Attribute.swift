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

    public var wrappedValue: T {
        do {
            return try transform(element.attribute(named: name))
        } catch {
            guard let defaultValue else { fatalError(error.localizedDescription) }
            return defaultValue
        }
    }
}

public protocol AttributeDecodable {
    init(from attribute: LiveViewNativeCore.Attribute?) throws
}

public enum AttributeDecodingError: LocalizedError {
    case missingAttribute(Any.Type)
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

extension String: AttributeDecodable {
    public init(from attribute: LiveViewNativeCore.Attribute?) throws {
        guard let attributeValue = attribute?.value else { throw AttributeDecodingError.missingAttribute(Self.self) }
        self = attributeValue
    }
}

extension Bool: AttributeDecodable {
    public init(from attribute: LiveViewNativeCore.Attribute?) throws {
        self = attribute != nil
    }
}

extension Double: AttributeDecodable {
    public init(from attribute: LiveViewNativeCore.Attribute?) throws {
        guard let attributeValue = attribute?.value else { throw AttributeDecodingError.missingAttribute(Self.self) }
        guard let result = Self(attributeValue) else { throw AttributeDecodingError.badValue(Self.self) }
        self = result
    }
}

extension AttributeDecodable where Self: RawRepresentable, RawValue == String {
    public init(from attribute: LiveViewNativeCore.Attribute?) throws {
        guard let attributeValue = attribute?.value else { throw AttributeDecodingError.missingAttribute(Self.self) }
        guard let value = Self(rawValue: attributeValue) else { throw AttributeDecodingError.badValue(Self.self) }
        self = value
    }
}
