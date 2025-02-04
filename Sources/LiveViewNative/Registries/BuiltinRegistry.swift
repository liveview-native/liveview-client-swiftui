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
        case background(_ViewModifier__background<R>)
        
        nonisolated init(from decoder: any Decoder) throws {
            var container = try decoder.singleValueContainer()
            
            if let modifier = try? container.decode(_ViewModifier__padding<R>.self) {
                self = .padding(modifier)
                return
            }
            
            if let modifier = try? container.decode(_ViewModifier__background<R>.self) {
                self = .background(modifier)
                return
            }
            
            let node = try container.decode(ASTNode.self)
            print(node)
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
            case let .background(__modifier):
                __content.modifier(__modifier)
            }
        }
    }
}

public struct _WithLVNContext<Root: RootRegistry, Content: View>: View {
    let content: (ElementNode, LiveContext<Root>) -> Content
    
    public init(registry _: Root.Type, @ViewBuilder content: @escaping (ElementNode, LiveContext<Root>) -> Content) {
        self.content = content
    }
    
    @ObservedElement private var element
    @LiveContext<Root> private var context
    
    public var body: some View {
        content(element, context)
    }
}

struct A: ViewModifier, @preconcurrency Decodable {
    let value: String
    
    init(_ value: String) {
        self.value = value
    }
    
    func body(content: Content) -> some View {
        content
    }
    
    enum CodingKeys: CodingKey {
        case value
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init(try container.decode(String.self, forKey: .value))
    }
}
