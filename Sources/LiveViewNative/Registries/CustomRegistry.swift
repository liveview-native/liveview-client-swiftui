//
//  CustomRegistry.swift
// LiveViewNative
//
//  Created by Shadowfacts on 2/16/22.
//

import SwiftUI
import LiveViewNativeCore

/// A custom registry allows clients to include custom view types in the LiveView DOM.
///
/// To add a custom element or attribute, define an enum for the type alias for the tag/attribute name and implement the appropriate method. To customize the loading view, implement the ``loadingView(for:state:)-6jd3b`` method.
///
/// To use a single registry, implement the ``RootRegistry`` protocol and implement the inherited `CustomRegistry` requirements. If you want to combine multiple registries, see ``AggregateRegistry``.
/// To use your registry, provide it as the generic parameter for the ``LiveSessionCoordinator`` you construct:
///
/// ```swift
/// struct ContentView: View {
///     @State var coordinator = LiveSessionCoordinator<MyRegistry>(...)
/// }
/// ```
///
/// ## Topics
/// ### Custom Tags
/// - ``TagName``
/// - ``lookup(_:element:context:)-5bvqg``
/// - ``CustomView``
/// ### Custom View Modifiers
/// - ``ModifierType``
/// - ``decodeModifier(_:from:context:)-4cqvs``
/// - ``CustomModifier``
/// ### Customizing the Loading View
/// - ``loadingView(for:state:)-6jd3b``
/// - ``LoadingView``
/// ### Composing Registries
/// - ``AggregateRegistry``
/// - ``RootRegistry``
/// - ``Root``
/// ### Supporting Types
/// - ``EmptyRegistry``
/// - ``ViewModifierBuilder``
public protocol CustomRegistry<Root> {
    /// The root custom registry type that the live view coordinator and context use.
    ///
    /// Conform you registry type to ``RootRegistry``, which sets this type to `Self` automatically, if you intend to use your registry directly.
    ///
    /// If you are composing multiple custom registries together or building a registry intended to incorporated into an aggregated registry, see ``AggregateRegistry``.
    associatedtype Root: RootRegistry
    
    /// A type representing the tag names that this registry type can provide views for.
    ///
    /// The tag name type must be `RawRepresentable` and its raw values must be strings. All raw value strings must be lowercased, otherwise the framework will not be able to construct your tag types from strings in the DOM.
    ///
    /// Generally, this is an enum which declares variants for the supported tags:
    /// ```swift
    /// struct MyRegistry: RootRegistry {
    ///     enum TagName: String {
    ///         case foo
    ///         case barBaz = "bar-baz"
    ///     }
    /// }
    /// ```
    ///
    /// This will default to the ``EmptyRegistry/None`` type if you don't support any custom tags.
    associatedtype TagName: RawRepresentable = EmptyRegistry.None where TagName.RawValue == String
    /// A type represnting the custom modifier types that this registry can handle.
    ///
    /// This type must be `RawRepresentable` and its raw values must be strings.
    ///
    /// Generally, this is an enum which declares variants for the support attributes:
    /// ```swift
    /// struct MyRegistry: RootRegistry {
    ///     enum AttributeName: String {
    ///         case foo
    ///         case barBaz
    ///     }
    /// }
    /// ```
    ///
    /// This will default to the ``EmptyRegistry/None`` type if you don't support any custom modifiers.
    associatedtype ModifierType: RawRepresentable = EmptyRegistry.None where ModifierType.RawValue == String
    /// The type of view this registry returns from the `lookup` method.
    ///
    /// Generally, implementors will use an opaque return type on their ``lookup(_:element:context:)-5bvqg`` implementations and this will be inferred automatically.
    associatedtype CustomView: View = Never
    /// The type of view modifier this registry returns from the `decodeModifiers` method.
    ///
    /// Generally, implementors will use an opaque return type on their ``decodeModifier(_:from:context:)-4cqvs`` implementations and this will be inferred automatically.
    associatedtype CustomModifier: ViewModifier = EmptyModifier
    /// The type of view this registry produces for loading views.
    ///
    /// Generally, implementors will use an opaque return type on their ``loadingView(for:state:)-6jd3b`` implementations and this will be inferred automatically.
    associatedtype LoadingView: View = Never
    /// The type of view this registry produces for error views.
    ///
    /// Generally, implementors will use an opaque return type on their ``errorView(for:)`` implementations and this will be inferred automatically.
    associatedtype ErrorView: View = Never
    /// The type of view this registry produces for stylesheets.
    associatedtype Stylesheet: StylesheetProtocol = EmptyStylesheet

    /// This method is called by LiveView Native when it needs to construct a custom view.
    ///
    /// If your custom registry does not support any elements, you can set the `TagName` type alias to ``EmptyRegistry/None`` and omit this method.
    ///
    /// - Parameter name: The name of the tag.
    /// - Parameter element: The element that a view should be created for.
    /// - Parameter context: The live context in which the view is being created.
    @ViewBuilder
    static func lookup(_ name: TagName, element: ElementNode) -> CustomView
    
    /// This method is called by LiveView Native when it encounters a view modifier your registry has declared support for.
    ///
    /// If your custom registry does not support any custom modifiers, you can set the `ModifierType` type alias to ``EmptyRegistry/None`` and omit this method.
    ///
    /// - Parameter type: The type of the modifier.
    /// - Parameter decoder: The decoder representing the JSON object of the modifier. Implement `Decodable` on your modifier type and call `MyModifier(from: decoder)` to use it.
    /// - Parameter context: The live context in which the view is being built.
    /// - Returns: A struct that implements the `SwiftUI.ViewModifier` protocol.
    /// - Throws: If decoding the modifier fails.
    @ViewModifierBuilder
    static func decodeModifier(_ type: ModifierType, from decoder: Decoder) throws -> CustomModifier
    
    /// This method is called when it needs a view to display while connecting to the live view.
    ///
    /// If you do not implement this method, the framework provides a loading view which displays a simple text representation of the state.
    ///
    /// - Parameter url: The URL of the view being connected to.
    /// - Parameter state: The current state of the coordinator. This method is never called with ``LiveSessionState/connected``.
    @ViewBuilder
    static func loadingView(for url: URL, state: LiveSessionState) -> LoadingView
    
    /// This method is called when it needs a view to display when an error occurs in the View hierarchy.
    ///
    /// If you do not implement this method, the framework provides a view which displays a simple text representation of the error.
    ///
    /// - Parameter error: The error of the view is reporting.
    @ViewBuilder
    static func errorView(for error: Error) -> ErrorView
}

extension CustomRegistry where LoadingView == Never {
    /// A default implementation that falls back to the default framework loading view.
    public static func loadingView(for url: URL, state: LiveSessionState) -> Never {
        fatalError()
    }
}

extension CustomRegistry where ErrorView == Never {
    /// A default implementation that falls back to the default framework error view.
    public static func errorView(for error: Error) -> Never {
        fatalError()
    }
}

/// The empty registry is the default ``CustomRegistry`` implementation that does not provide any views or modifiers.
public struct EmptyRegistry {
}
extension EmptyRegistry: RootRegistry {
    /// A type that can be used as ``CustomRegistry/TagName`` or ``CustomRegistry/ModifierType`` for registries which don't support any custom tags or attributes.
    public struct None: RawRepresentable {
        public typealias RawValue = String
        public var rawValue: String
        
        public init?(rawValue: String) {
            return nil
        }
    }
    public typealias TagName = None
    public typealias ModifierType = None
}
extension CustomRegistry where TagName == EmptyRegistry.None, CustomView == Never {
    /// A default implementation that does not provide any custom elements. If you omit the ``CustomRegistry/TagName`` type alias, this implementation will be used.
    public static func lookup(_ name: TagName, element: ElementNode) -> Never {
        fatalError()
    }
}
extension CustomRegistry where ModifierType == EmptyRegistry.None, CustomModifier == EmptyModifier {
    /// A default implementation that does not provide any custom modifiers. If you omit the ``CustomRegistry/ModifierType`` type alias, this implementation will be used.
    public static func decodeModifier(_ type: ModifierType, from decoder: Decoder) -> EmptyModifier {
        EmptyModifier()
    }
}

/// A root registry is a ``CustomRegistry`` type that can be used directly as the registry for a ``LiveSessionCoordinator``.
public protocol RootRegistry: CustomRegistry where Root == Self {
}

/// The stylesheet protocol can be defined within a ``CustomRegistry`` to apply modifiers to views based on class names.
public protocol StylesheetProtocol: ViewModifier {
    init(_ className: String)
}

public struct EmptyStylesheet: StylesheetProtocol {
    public init(_ className: String) {}
    
    public func body(content: Content) -> some View {
        content
    }
}
