//
//  ViewRegistry.swift
// LiveViewNative
//
//  Created by Shadowfacts on 2/11/22.
//

import SwiftUI
import LiveViewNativeCore
import LiveViewNativeStylesheet

/// This protocol provides access to the `ViewModifier` type returned from `decodeModifier` in the `BuiltinRegistry`.
/// That type is used by `ModifierContainer.builtin`.
protocol BuiltinRegistryProtocol {
    associatedtype BuiltinModifier: ViewModifier & Decodable
}

@MainActor
struct BuiltinRegistry<R: RootRegistry>: BuiltinRegistryProtocol {
    static func lookup(_ name: String, _ element: ElementNode) -> some View {
        return BuiltinElement<R>(name: name, element: element)
    }
}

enum BuiltinRegistryModifierError: Error {
    case unknownModifier
}

extension BuiltinRegistry {
    enum BuiltinModifier: ViewModifier, Decodable {
        case __customRegistry(R.CustomModifier)
        case __error(ErrorModifier<R>)
        
        case padding(_ViewModifier__padding<R>)
        
        nonisolated init(from decoder: any Decoder) throws {
            var container = try decoder.singleValueContainer()
            
            if let modifier = try? container.decode(_ViewModifier__padding<R>.self) {
                self = .padding(modifier)
            }
            
            let node = try container.decode(ASTNode.self)
            self = .__error(ErrorModifier(type: node.identifier, error: BuiltinRegistryModifierError.unknownModifier))
        }
        
        @ViewBuilder
        func body(content __content: Content) -> some View {
            switch self {
            case let .__customRegistry(modifier):
                __content.modifier(modifier)
            case let .__error(modifier):
                __content.modifier(modifier)
            case let .padding(__modifier):
                __content.modifier(__modifier)
            }
        }
    }
}

@ASTDecodable("A")
struct A {
    let value: String
    
    init(_ value: String) {
        self.value = value
    }
}
