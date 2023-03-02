//
//  Attribute.swift
//  
//
//  Created by Carson Katri on 2/28/23.
//

import SwiftUI
import LiveViewNativeCore

@propertyWrapper
public struct Attribute<T>: DynamicProperty where T: AttributeDecodable {
    @ObservedElement private var element
    private let name: AttributeName
    private let defaultValue: T?

    public init(wrappedValue: T? = nil, _ name: AttributeName) {
        self.name = name
        self.defaultValue = wrappedValue
    }

    public var wrappedValue: T {
        do {
            return try T(from: element.attribute(named: name))
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
