//
//  AggregateRegistry.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 2/23/23.
//

import Foundation
import SwiftUI
import LiveViewNativeStylesheet

/// A macro that combines multiple registries together.
///
/// ```swift
/// struct AppRegistries: AggregateRegistry {
///     #Registries<
///         MyRegistry,
///         LiveFormsRegistry<Self>,
///         AVKitRegistry<Self>
///     >
/// }
/// ```
@freestanding(declaration, names: named(Registries))
public macro Registries() = #externalMacro(module: "LiveViewNativeMacros", type: "RegistriesMacro")

/// An aggregate registry combines multiple other registries together, allowing you to use tags/modifiers declared by any of them.
///
/// In Swift 5.9, use the ``LiveViewNative/Registries`` macro to combine registries together.
///
/// ```swift
/// struct AppRegistries: AggregateRegistry {
///     #Registries<
///         MyRegistry,
///         LiveFormsRegistry<Self>,
///         AVKitRegistry<Self>
///     >
/// }
/// ```
///
/// When using a Swift version < 5.9, conform to this protocol manually, provide the `Registries` typealias using the `Registry2`/`Registry3`/etc. types:
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
    
    public static func errorView(for error: Error) -> some View {
        return Registries.errorView(for: error)
    }
    
    public static func parseModifier(
        _ input: inout Substring.UTF8View,
        in context: ParseableModifierContext
    ) throws -> some (ViewModifier & ParseableModifierValue) {
        return try Registries.parseModifier(&input, in: context)
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

public enum _EitherCustomModifier<First: CustomRegistry, Second: CustomRegistry>: ViewModifier & ParseableModifierValue {
    case first(First.CustomModifier)
    case second(Second.CustomModifier)
    
    public static func parser(in context: ParseableModifierContext) -> _ParserType {
        _ParserType(context: context)
    }
    
    @MainActor
    public struct _ParserType: @preconcurrency Parser {
        let context: ParseableModifierContext
        
        public func parse(_ input: inout Substring.UTF8View) throws -> _EitherCustomModifier<First, Second> {
            let copy = input
            let firstError: ModifierParseError?
            do {
                return .first(try First.parseModifier(&input, in: context))
            } catch let error as ModifierParseError {
                firstError = error
            } catch {
                firstError = nil
            }
            
            // backtrack and try second
            input = copy
            do {
                return .second(try Second.parseModifier(&input, in: context))
            } catch let error as ModifierParseError {
                if let firstError {
                    let firstFailures = if case let .multiRegistryFailure(failures) = firstError.error {
                        failures
                    } else {
                        [(First.self, firstError.error)]
                    }
                    let secondFailures = if case let .multiRegistryFailure(failures) = error.error {
                        failures
                    } else {
                        [(Second.self, error.error)]
                    }
                    throw ModifierParseError(
                        error: .multiRegistryFailure(
                            firstFailures + secondFailures
                        ),
                        metadata: error.metadata
                    )
                } else {
                    throw error
                }
            } catch {
                if let firstError {
                    throw firstError
                } else {
                    throw error
                }
            }
        }
    }
    
    public func body(content: Content) -> some View {
        switch self {
        case .first(let first):
            content.modifier(first)
        case .second(let second):
            content.modifier(second)
        }
    }
}

/// A registry implementation that combines two registries. Use the `Registry2`/etc. typealiases rather than using this type directly.
public struct _MultiRegistry<First: CustomRegistry, Second: CustomRegistry>: CustomRegistry where First.Root == Second.Root {
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
    
    public static func errorView(for error: Error) -> some View {
        return First.errorView(for: error)
    }
    
    public static func parseModifier(
        _ input: inout Substring.UTF8View,
        in context: ParseableModifierContext
    ) throws -> _EitherCustomModifier<First, Second> {
        return try _EitherCustomModifier<First, Second>.parser(in: context).parse(&input)
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

public struct _SpecializedEmptyRegistry<Root: RootRegistry>: CustomRegistry {}
