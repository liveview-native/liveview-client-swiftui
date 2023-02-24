//
//  AggregateRegistry.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 2/23/23.
//

import Foundation
import SwiftUI

public protocol AggregateRegistry: RootRegistry {
    associatedtype Registries: CustomRegistry where Registries.Root == Self
}

extension AggregateRegistry {
    public static func lookup(_ name: Registries.TagName, element: ElementNode, context: LiveContext<Root>) -> some View {
        return Registries.lookup(name, element: element, context: context)
    }

    public static func decodeModifier(_ type: Registries.ModifierType, from decoder: Decoder, context: LiveContext<Root>) throws -> some ViewModifier {
        return try Registries.decodeModifier(type, from: decoder, context: context)
    }

    public static func loadingView(for url: URL, state: LiveSessionState) -> some View {
        return Registries.loadingView(for: url, state: state)
    }
}

public enum _EitherRawString<First: RawRepresentable<String>, Second: RawRepresentable<String>>: RawRepresentable {
    case first(First)
    case second(Second)

    public init?(rawValue: String) {
        if let name = First(rawValue: rawValue) {
            self = .first(name)
        } else if let name = Second(rawValue: rawValue) {
            self = .second(name)
        } else {
            return nil
        }
    }

    public var rawValue: String {
        switch self {
        case .first(let name):
            return name.rawValue
        case .second(let name):
            return name.rawValue
        }
    }
}

@frozen public struct _MultiRegistry<First: CustomRegistry, Second: CustomRegistry>: CustomRegistry where First.Root == Second.Root {
    public typealias Root = First.Root
    
    public typealias TagName = _EitherRawString<First.TagName, Second.TagName>

    public static func lookup(_ name: TagName, element: ElementNode, context: LiveContext<First.Root>) -> some View {
        switch name {
        case .first(let name):
            First.lookup(name, element: element, context: context)
        case .second(let name):
            Second.lookup(name, element: element, context: context)
        }
    }

    public typealias ModifierType = _EitherRawString<First.ModifierType, Second.ModifierType>

    public static func decodeModifier(_ type: ModifierType, from decoder: Decoder, context: LiveContext<First.Root>) throws -> some ViewModifier {
        switch type {
        case .first(let type):
            try First.decodeModifier(type, from: decoder, context: context)
        case .second(let type):
            try Second.decodeModifier(type, from: decoder, context: context)
        }
    }

    public static func loadingView(for url: URL, state: LiveSessionState) -> some View {
        return First.loadingView(for: url, state: state)
    }
}

public typealias Registry2<T0: CustomRegistry, T1: CustomRegistry>
    = _MultiRegistry<T0, T1>
    where T0.Root == T1.Root
public typealias Registry3<T0: CustomRegistry, T1: CustomRegistry, T2: CustomRegistry>
    = _MultiRegistry<_MultiRegistry<T0, T1>, T2>
    where T0.Root == T1.Root, T0.Root == T2.Root
public typealias Registry4<T0: CustomRegistry, T1: CustomRegistry, T2: CustomRegistry, T3: CustomRegistry>
    = _MultiRegistry<_MultiRegistry<T0, T1>, _MultiRegistry<T2, T3>>
    where T0.Root == T1.Root, T0.Root == T2.Root, T0.Root == T3.Root
