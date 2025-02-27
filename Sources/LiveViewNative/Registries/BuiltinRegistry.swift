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

/// A type that decodes the name from an AST node, then throws itself as an
/// error to avoid consuming the value.
struct ModifierTypeName: Decodable, LocalizedError {
    let name: String
    
    init(name: String) {
        self.name = name
    }
    
    init(from decoder: any Decoder) throws {
        var container = try decoder.unkeyedContainer()
        throw Self(name: try container.decode(String.self))
    }
    
    var errorDescription: String? {
        "Unknown modifier '\(name)'"
    }
}

//extension BuiltinRegistry {
//    enum BuiltinModifier: ViewModifier, Decodable {
//        case __customRegistry(R.CustomModifier)
//        case __error(ErrorModifier<R>)
//        
//        case padding(_ViewModifier__padding<R>)
//        case background(_ViewModifier__background<R>)
//        
//        nonisolated init(from decoder: any Decoder) throws {
//            var container = try decoder.singleValueContainer()
//            
//            do {
//                try container.decode(ModifierTypeName.self)
//                throw BuiltinRegistryModifierError.unknownModifier
//            } catch let modifierTypeName as ModifierTypeName {
//                switch modifierTypeName.name {
//                case "padding":
//                    self = .padding(try container.decode(_ViewModifier__padding<R>.self))
//                case "background":
//                    self = .background(try container.decode(_ViewModifier__background<R>.self))
//                default:
//                    let node = try container.decode(ASTNode.self)
//                    print(node)
//                    self = .__error(ErrorModifier(type: node.identifier, error: BuiltinRegistryModifierError.unknownModifier))
//                }
//            } catch {
//                throw error
//            }
//        }
//        
//        @ViewBuilder
//        func body(content __content: Content) -> some View {
//            switch self {
//            case let .__customRegistry(modifier):
//                __content.modifier(modifier)
//            case let .__error(modifier):
//                __content.modifier(modifier)
//            case let .padding(__modifier):
//                __content.modifier(__modifier)
//            case let .background(__modifier):
//                __content.modifier(__modifier)
//            }
//        }
//    }
//}
