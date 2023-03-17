//
//  AggregateRegistry.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 2/23/23.
//

import Foundation
import SwiftUI

/// An aggregate registry combines multiple other registries together, allowing you to use tags/modifiers declared by any of them.
///
/// To conform to this protocol, provide the `Registries` typealias, using the `Registry2`/`Registry3`/etc. types:
/// ```swift
/// struct AppRegistries: AggregateRegistry {
///     typealias Registries = Registry2<
///         MyRegistry,
///         LiveFormsRegistry<Self>
///     >
/// }
/// ```
///
/// To use your aggregate registry, pass it as the type parameter when you're constructing the ``LiveSessionCoordinator``:
/// ```swift
/// struct ContentView: View {
///     @State var session = LiveSessionCoordinator<AppRegistries>(url: URL(string: "...")!)
/// }
/// ```
///
/// Note that each of the registry types used in the aggregate registry must specify that its root registry type is your aggregate registry.
/// This is required so that inside of an element provided by one registry, there can also be elements provided by any of the other registries that are aggregated together.
///
/// If you're implementing a registry for use within your own app, you can specify the root registry explicitly:
/// ```swift
/// struct MyRegistry: CustomRegistry {
///     typealias Root = AppRegistries
///     // ...
/// }
/// ```
/// Or, if you're implementing a registry as part of a library that will be used by another app, you can make your registry type generic over the root type:
/// ```swift
/// struct LiveFormsRegistry<Root: RootRegistry>: CustomRegistry {
///     // ...
/// }
/// ```
///
/// ### Loading Views
/// Whereas tags and modifiers can be composed from multiple registry types without conflict, only one loading view implementation can be used.
/// The aggregate registry will use the loading view from the first concrete registry type that is provided.
/// In the above example, `AppRegistries` would use `MyRegistry`'s loading view by default.
///
/// If you don't want this behavior, you can override ``CustomRegistry/loadingView(for:state:)-6jd3b`` on your aggregate registry and provide another view.
///
/// ## Topics
/// ### Protocol Requirements
/// - ``Registries``
/// ### Multi-Registry Types
/// - ``Registry2``
/// - ``Registry3``
/// - ``Registry4``
public protocol AggregateRegistry: RootRegistry {
    /// The combined registry type.
    ///
    /// - Note: The ``CustomRegistry/Root`` associated type of the combined registry must be your aggregate registry.
    associatedtype Registries: CustomRegistry where Registries.Root == Self
}

extension AggregateRegistry {
    public static func lookup(_ name: Registries.TagName, element: ElementNode) -> some View {
        return Registries.lookup(name, element: element)
    }

    public static func decodeModifier(_ type: Registries.ModifierType, from decoder: Decoder) throws -> some ViewModifier {
        return try Registries.decodeModifier(type, from: decoder)
    }

    public static func loadingView(for url: URL, state: LiveSessionState) -> some View {
        return Registries.loadingView(for: url, state: state)
    }
}

/// A helper type that represents either one of two `RawRepresentable<String>` types.
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

/// A registry implementation that combines two registries. Use the `Registry2`/etc. typealiases rather than using this type directly.
@frozen public struct _MultiRegistry<First: CustomRegistry, Second: CustomRegistry>: CustomRegistry where First.Root == Second.Root {
    public typealias Root = First.Root
    
    public typealias TagName = _EitherRawString<First.TagName, Second.TagName>

    public static func lookup(_ name: TagName, element: ElementNode) -> some View {
        switch name {
        case .first(let name):
            First.lookup(name, element: element)
        case .second(let name):
            Second.lookup(name, element: element)
        }
    }

    public typealias ModifierType = _EitherRawString<First.ModifierType, Second.ModifierType>

    public static func decodeModifier(_ type: ModifierType, from decoder: Decoder) throws -> some ViewModifier {
        switch type {
        case .first(let type):
            try First.decodeModifier(type, from: decoder)
        case .second(let type):
            try Second.decodeModifier(type, from: decoder)
        }
    }

    public static func loadingView(for url: URL, state: LiveSessionState) -> some View {
        return First.loadingView(for: url, state: state)
    }
}

/// A registry type that combines 2 registries.
public typealias Registry2<T0: CustomRegistry, T1: CustomRegistry>
    = _MultiRegistry<T0, T1>
    where T0.Root == T1.Root
///A registry type that combines 3 registries.
public typealias Registry3<T0: CustomRegistry, T1: CustomRegistry, T2: CustomRegistry>
    = _MultiRegistry<_MultiRegistry<T0, T1>, T2>
    where T0.Root == T1.Root, T0.Root == T2.Root
/// A registry type that combines 4 registries.
public typealias Registry4<T0: CustomRegistry, T1: CustomRegistry, T2: CustomRegistry, T3: CustomRegistry>
    = _MultiRegistry<_MultiRegistry<T0, T1>, _MultiRegistry<T2, T3>>
    where T0.Root == T1.Root, T0.Root == T2.Root, T0.Root == T3.Root
