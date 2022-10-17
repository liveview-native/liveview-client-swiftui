//
//  CustomRegistry.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 2/16/22.
//

import SwiftUI
import LiveViewNativeCore

/// A custom registry allows clients to include custom view types in the LiveView DOM.
///
/// To add a custom element or attribute, define an enum for the type alias for the tag/attribute name and implement the appropriate method. To customize the loading view, implement the ``loadingView(for:state:)-vg2v`` method.
///
/// To use your custom registry implementation, provide it as the generic parameter for the ``LiveViewCoordinator`` you construct:
///
/// ```swift
/// struct ContentView: View {
///     @State var coordinator = LiveViewCoordinator<MyRegistry>(...)
/// }
/// ```
///
/// ## Topics
/// ### Custom Tags
/// - ``TagName``
/// - ``lookup(_:element:context:)-2rzrl``
/// ### Custom Attributes
/// - ``AttributeName``
/// - ``lookupModifier(_:value:element:context:)-9qdm4``
/// ### Customizing the Loading View
/// - ``loadingView(for:state:)-vg2v``
/// ### See Also
/// - ``EmptyRegistry``
public protocol CustomRegistry {
    /// A type representing the tag names that this registry type can provide views for.
    ///
    /// The tag name type must be `RawRepresentable` and its raw values must be strings. All raw value strings must be lowercased, otherwise the framework will not be able to construct your tag types from strings in the DOM.
    ///
    /// Generally, this is an enum which declares variants for the supported tags:
    /// ```swift
    /// struct MyRegistry: CustomRegistry {
    ///     enum TagName: String {
    ///         case foo
    ///         case barBaz = "bar-baz"
    ///     }
    /// }
    /// ```
    ///
    /// If your registry does not support any custom tags, you can set this type alias to the ``EmptyRegistry/None`` type:
    /// ```swift
    /// struct MyRegistry: CustomRegistry {
    ///     typealias TagName = EmptyRegistry.None
    /// }
    /// ```
    associatedtype TagName: RawRepresentable where TagName.RawValue == String
    /// A type represnting the attribute names that this registry can handle.
    ///
    /// The attribute name type must be `RawRepresentable` and its raw values must be strings. All raw value strings must be lowercased, otherwise the framework will not be able to construct your attribute types from strings in the DOM.
    ///
    /// Generally, this is an enum which declares variants for the support attributes:
    /// ```swift
    /// struct MyRegistry: CustomRegistry {
    ///     enum AttributeName: String {
    ///         case foo
    ///         case barBaz = "bar-baz"
    ///     }
    /// }
    /// ```
    ///
    /// If your registry does not support any custom attributes, you can set this type alias to the ``EmptyRegistry/None`` type:
    /// ```swift
    /// struct MyRegistry: CustomRegistry {
    ///     typealias AttributeName = EmptyRegistry.None
    /// }
    /// ```
    associatedtype AttributeName: RawRepresentable where AttributeName.RawValue == String
    /// The type of view this registry returns from the `lookup` method.
    ///
    /// Generally, implementors will use an opaque return type on their ``lookup(_:element:context:)-2rzrl`` implementations and this will be inferred automatically.
    associatedtype CustomView: View
    /// The type of view this registry produces for loading views.
    ///
    /// Generally, implementors will use an opaque return type on their ``loadingView(for:state:)-vg2v`` implementations and this will be inferred automatically.
    associatedtype LoadingView: View
    
    /// This method is called by LiveView Native when it needs to construct a custom view.
    ///
    /// If your custom registry does not support any elements, you can set the `TagName` type alias to ``EmptyRegistry/None`` and omit this method.
    ///
    /// - Parameter name: The name of the tag.
    /// - Parameter element: The element that a view should be created for.
    /// - Parameter context: The live context in which the view is being created.
    @ViewBuilder
    static func lookup(_ name: TagName, element: ElementNode, context: LiveContext<Self>) -> CustomView
    
    /// This method is called by LiveView Native when it encounters a custom attribute your registry has declared support for.
    ///
    /// If your custom registry does not support any attributes, you can set the `AttributeName` type alias to ``EmptyRegistry/None`` and omit this method.
    ///
    /// - Parameter name: The name of the attribute.
    /// - Parameter value: The value of the attribute. `nil` if no value is provided in the DOM.
    /// - Parameter element: The element on which the attribute is present.
    /// - Parameter context: The live context in which the view is being built.
    /// - Returns: A struct that implements the `SwiftUI.ViewModifier` protocol.
    static func lookupModifier(_ name: AttributeName, value: String?, element: ElementNode, context: LiveContext<Self>) -> any ViewModifier
    
    /// This method is called when it needs a view to display while connecting to the live view.
    ///
    /// If you do not implement this method, the framework provides a loading view which displays a simple text representation of the state.
    ///
    /// - Parameter url: The URL of the view being connected to.
    /// - Parameter state: The current state of the coordinator. This method is never called with ``LiveViewCoordinator/State-swift.enum/connected``.
    @ViewBuilder
    static func loadingView(for url: URL, state: LiveViewCoordinator<Self>.State) -> LoadingView
}

extension CustomRegistry where LoadingView == Never {
    /// A default  implementation that falls back to the default framework loading view.
    public static func loadingView(for url: URL, state: LiveViewCoordinator<Self>.State) -> Never {
        fatalError()
    }
}

/// The empty registry is the default ``CustomRegistry`` implementation that does not provide any views or modifiers.
public struct EmptyRegistry {
}
extension EmptyRegistry: CustomRegistry {
    /// A type that can be used as ``CustomRegistry/TagName`` or ``CustomRegistry/AttributeName`` for registries which don't support any custom tags or attributes.
    public struct None: RawRepresentable {
        public typealias RawValue = String
        public var rawValue: String
        
        public init?(rawValue: String) {
            return nil
        }
    }
    
    public typealias TagName = None
    public typealias AttributeName = None
}
extension CustomRegistry where TagName == EmptyRegistry.None, CustomView == Never {
    /// A default implementation that does not provide any custom elements. If you omit the ``CustomRegistry/TagName`` type alias, this implementation will be used.
    public static func lookup(_ name: TagName, element: ElementNode, context: LiveContext<Self>) -> Never {
        fatalError()
    }
}
extension CustomRegistry where AttributeName == EmptyRegistry.None {
    /// A default implementation that does not provide any custom attributes. If you omit the ``CustomRegistry/AttributeName`` type alias, this implementation will be used.
    public static func lookupModifier(_ name: AttributeName, value: String?, element: ElementNode, context: LiveContext<Self>) -> any ViewModifier {
        fatalError()
    }
}
