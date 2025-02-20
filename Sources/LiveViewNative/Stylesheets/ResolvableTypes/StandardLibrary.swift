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
    @MainActor
    enum Resolvable: StylesheetResolvable, @preconcurrency Decodable {
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
    struct Resolvable: @preconcurrency Decodable, StylesheetResolvable {
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

extension StylesheetResolvableRangeExpression: @preconcurrency AttributeDecodable {
    nonisolated init(from attribute: Attribute?, on element: ElementNode) throws {
        fatalError()
    }
}

extension Double {
    enum Resolvable: StylesheetResolvable, @preconcurrency Decodable {
        case __constant(Double)
        case reference(AttributeReference<Double>)
        
        @ASTDecodable("Double")
        enum Member: @preconcurrency Decodable {
            case infinity
            case pi
        }
        
        init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()
            
            if let member = try? container.decode(Member.self) {
                switch member {
                case .infinity:
                    self = .__constant(.infinity)
                case .pi:
                    self = .__constant(.pi)
                }
            } else {
                self = .reference(try container.decode(AttributeReference<Double>.self))
            }
        }
        
        func resolve<R>(on element: ElementNode, in context: LiveContext<R>) -> Double where R : RootRegistry {
            switch self {
            case let .__constant(constant):
                return constant
            case let .reference(reference):
                return reference.resolve(on: element, in: context)
            }
        }
    }
}
