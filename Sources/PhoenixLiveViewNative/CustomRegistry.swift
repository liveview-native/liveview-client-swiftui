//
//  CustomRegistry.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 2/16/22.
//

import SwiftUI
import SwiftSoup

// typealias so people implementing CustomRegistry don't have to also import SwiftSoup
public typealias Element = SwiftSoup.Element

/// A custom registry allows clients to include custom view types in the LiveView DOM.
public protocol CustomRegistry {
    /// The type of view this registry returns.
    ///
    /// Generally, implementors will use an opaque return type on their ``lookup(_:element:coordinator:context:)`` implementations and this will be inferred automatically.
    associatedtype V: View
    
    /// The list of tag names that this custom registry can produce views for. All tag names should be lowercased.
    var supportedTagNames: [String] { get }
    
    /// This method is called by LiveView Native when it needs to construct a custom view.
    ///
    /// This method will only be called with tag names which you have declared in ``supportedTagNames``.
    ///
    /// - Parameter name: The name of the tag, already lowercased.
    /// - Parameter element: The element that a view should be created for.
    /// - Parameter context: The live context in which the view is being created.
    func lookup(_ name: String, element: Element, coordinator: LiveViewCoordinator<Self>, context: LiveContext<Self>) -> V
}

/// The empty registry is the default ``CustomRegistry`` implementation that does not provide any views.
public struct EmptyRegistry: CustomRegistry {
    public let supportedTagNames: [String] = []
    
    public func lookup(_ name: String, element: Element, coordinator: LiveViewCoordinator<EmptyRegistry>, context: LiveContext<EmptyRegistry>) -> Never {
        fatalError()
    }
}
