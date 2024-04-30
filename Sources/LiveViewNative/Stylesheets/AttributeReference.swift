//
//  AttributeReference.swift
//
//
//  Created by Carson Katri on 10/24/23.
//

import LiveViewNativeStylesheet
import LiveViewNativeCore

/// An `attr("...")` reference in a stylesheet, or a concrete value.
///
/// The value associated with the specified attribute will be passed to the modifier.
///
/// ```elixir
/// attr("my-attr-value")
/// ```
///
/// ```html
/// <Element my-attr-value="..." />
/// ```
///
/// The attribute will be automatically decoded to the correct type using the conformance to ``AttributeDecodable``.
public struct AttributeReference<Value: ParseableModifierValue & AttributeDecodable>: ParseableModifierValue {
    enum Storage {
        case constant(Value)
        case reference(AttributeName)
    }
    
    let storage: Storage
    
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            Value.parser(in: context).map(Storage.constant)
            AttributeName.parser(in: context).map(Storage.reference)
        }
        .map(Self.init)
    }
    
    public func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Value {
        resolve(on: element)
    }
    
    public func resolve(on element: ElementNode) -> Value {
        switch storage {
        case .constant(let value):
            return value
        case .reference(let name):
            return try! element.attributeValue(Value.self, for: name)
        }
    }
}

extension AttributeName: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ASTNode("__attr__", in: context) {
            String.parser(in: context)
        }
        .map({ Self.init(rawValue: $1)! })
    }
}
