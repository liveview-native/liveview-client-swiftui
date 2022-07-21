//
//  CustomRegistry.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 2/16/22.
//

import SwiftUI
import SwiftSoup

// typealiases so people implementing CustomRegistry don't have to also import SwiftSoup
public typealias Element = SwiftSoup.Element
public typealias Attribute = SwiftSoup.Attribute

/// A custom registry allows clients to include custom view types in the LiveView DOM.
public protocol CustomRegistry {
    /// The type of view this registry returns from .
    ///
    /// Generally, implementors will use an opaque return type on their ``lookup(_:element:context:)`` implementations and this will be inferred automatically.
    associatedtype V: View
    /// The type of view this registry produces for custom attributes.
    ///
    /// Generally, implementors will use an opaque return type on their ``applyCustomAttribute(_:element:context:)`` implementations and this will be inferred automatically.
    associatedtype Modified: View
    /// The type of view this registry produces for loading views.
    ///
    /// Generally, implementors will use an opaque return type on their ``loadingView(for:state:)-vg2v`` implementations and this will be inferred automatically.
    associatedtype LoadingView: View
    
    /// The list of tag names that this custom registry can produce views for. All tag names should be lowercased.
    static var supportedTagNames: [String] { get }
    
    ///  The list of attribute names that this custom registry can produce views for. All attribute names should be lowercased.
    static var supportedAttributes: [String] { get }
    
    /// This method is called by LiveView Native when it needs to construct a custom view.
    ///
    /// This method will only be called with tag names which you have declared in ``supportedTagNames``.
    ///
    /// - Parameter name: The name of the tag, already lowercased.
    /// - Parameter element: The element that a view should be created for.
    /// - Parameter context: The live context in which the view is being created.
    @ViewBuilder
    static func lookup(_ name: String, element: Element, context: LiveContext<Self>) -> V
    
    /// This method is called by LiveView Native when it encounters a custom attribute your registry has declared support for.
    ///
    /// Use ``LiveContext/buildElement(_:)`` to create the view you are going to modify.
    ///
    /// - Parameter attr: The key and value (if present) of the attribute.
    /// - Parameter element: The element on which the attribute is present.
    /// - Parameter context: The live context in which the view is being built.
    @ViewBuilder
    static func applyCustomAttribute(_ attr: Attribute, element: Element, context: LiveContext<Self>) -> Modified
    
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
    public static func loadingView(for url: URL, state: LiveViewCoordinator<Self>.State) -> Never {
        fatalError()
    }
}

/// The empty registry is the default ``CustomRegistry`` implementation that does not provide any views or modifiers.
public struct EmptyRegistry: CustomRegistry {
    public static let supportedTagNames: [String] = []
    public static let supportedAttributes: [String] = []
    
    public static func lookup(_ name: String, element: Element, context: LiveContext<EmptyRegistry>) -> Never {
        fatalError()
    }
    
    public static func applyCustomAttribute(_ attr: Attribute, element: Element, context: LiveContext<EmptyRegistry>) -> Never {
        fatalError()
    }
}
