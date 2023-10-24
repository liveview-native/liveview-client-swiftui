//
//  AttributeReference.swift
//
//
//  Created by Carson Katri on 10/24/23.
//

import LiveViewNativeStylesheet
import LiveViewNativeCore

struct AttributeReference<Value: ParseableModifierValue & AttributeDecodable>: ParseableModifierValue {
    enum Storage {
        case constant(Value)
        case reference(String)
    }
    
    let storage: Storage
    
    static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            Value.parser(in: context).map(Storage.constant)
            ASTNode("__attr__") {
                String.parser(in: context)
            }
            .map({ Storage.reference($1) })
        }
        .map(Self.init)
    }
    
    func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Value {
        switch storage {
        case .constant(let value):
            return value
        case .reference(let name):
            return try! element.attributeValue(Value.self, for: AttributeName(rawValue: name)!)
        }
    }
}
