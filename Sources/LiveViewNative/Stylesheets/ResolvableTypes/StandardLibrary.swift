//
//  Swift.swift
//  LiveViewNative
//
//  Created by Carson.Katri on 1/30/25.
//

import LiveViewNativeStylesheet
import LiveViewNativeCore

extension AnyHashable {
    @ASTDecodable("AnyHashable")
    enum Resolvable: StylesheetResolvable {
        case __constant(AnyHashable)
        case _string(AttributeReference<String>)
        
        init(_ string: AttributeReference<String>) {
            self = ._string(string)
        }
    }
}

extension AnyHashable.Resolvable {
    @MainActor func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> AnyHashable {
        switch self {
        case let .__constant(value):
            return value
        case let ._string(string):
            return AnyHashable(string.resolve(on: element, in: context))
        }
    }
}

extension Character {
    struct Resolvable: Decodable, StylesheetResolvable {
        let value: AttributeReference<String>
        
        init(from decoder: any Decoder) throws {
            self.value = try decoder.singleValueContainer().decode(AttributeReference<String>.self)
        }
        
        @MainActor func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Character {
            Character(value.resolve(on: element, in: context))
        }
    }
}

enum StylesheetResolvableRangeExpression: Decodable {
    case __never
    
    func resolve<R: RootRegistry, Bound>(on element: ElementNode, in context: LiveContext<R>) -> Range<Bound> {
        fatalError()
    }
}

extension StylesheetResolvableRangeExpression: AttributeDecodable {
    nonisolated init(from attribute: Attribute?, on element: ElementNode) throws {
        fatalError()
    }
}
