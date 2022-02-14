//
//  ViewRegistry.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 2/11/22.
//

import SwiftUI
import SwiftSoup

// typealias so people implementing PhxView don't have to also import SwiftSoup
public typealias Element = SwiftSoup.Element

/// This protocol is implemented by view types which are registered with the ``LiveViewRegistry``.
public protocol PhxView: View {
    /// Constructs this view from the given DOM element and live context.
    ///
    /// To convert children of the given element into a SwiftUI view-tree to be used as a child of your own implementation, use ``LiveContext/buildChildren(of:)``.
    init(element: Element, context: LiveContext)
}

private let reservedNames = ["textfield", "text", "hstack", "vstack", "zstack", "button", "form", "img", "scroll", "spacer", "navigation", "list", "roundrect"]

/// The view registry handles looking View implementations from tag names.
///
/// Client apps do not use the registry to lookup views. Intead, use the ``LiveContext/buildElement(_:)`` and ``LiveContext/buildChildren(of:)`` methods.
public class LiveViewRegistry {
    /// The default registry used by ``LiveViewCoordinator``s unless otherwise specified.
    public static let shared = LiveViewRegistry()
    
    private var viewInitializers = [String: (Element, LiveContext) -> AnyView]()
    
    /// Registers a custom view type.
    ///
    /// - Warning: Registering a view with the same name as a builtin view or an already-registered view is forbidden.
    public func register<V: PhxView>(_ type: V.Type, as name: String) {
        let name = normalizeName(name)
        precondition(!reservedNames.contains(name), "cannot register view with reserved name '\(name)'")
        precondition(!viewInitializers.keys.contains(name), "cannot re-register view named '\(name)'")
        viewInitializers[name] = { element, context in
            AnyView(V(element: element, context: context))
        }
    }
    
    func lookup(_ name: String, _ element: Element, _ coordinator: LiveViewCoordinator) -> some View {
        return lookup(name, element, coordinator, context: LiveContext(coordinator: coordinator))
    }
    
    @ViewBuilder
    func lookup(_ name: String, _ element: Element, _ coordinator: LiveViewCoordinator, context: LiveContext) -> some View {
        // Note: Builtin views are not registered, they are constructed manually with the switch to avoid using AnyView where possible.
        
        let name = normalizeName(name)
        switch name {
        case "textfield":
            PhxTextField(element: element, coordinator: coordinator, context: context)
        case "text":
            PhxText(element: element, coordinator: coordinator)
        case "hstack":
            PhxHStack(element: element, context: context)
        case "vstack":
            PhxVStack(element: element, context: context)
        case "zstack":
            PhxZStack(element: element, context: context)
        case "button":
            PhxButton(element: element, context: context)
        case "form":
            PhxForm(element: element, context: context)
        case "img":
            PhxImage(element: element, coordinator: coordinator)
        case "scroll":
            PhxScrollView(element: element, context: context)
        case "spacer":
            Spacer()
        case "navigation":
            PhxNavigationView(element: element, context: context)
        case "list":
            PhxList(element: element, context: context)
        case "roundrect":
            PhxShape(element: element, shape: RoundedRectangle(from: element))
        default:
            if let f = viewInitializers[name] {
                f(element, context)
            } else {
                // log here that view type cannot be found
                EmptyView()
            }
        }
    }
    
    private func normalizeName(_ name: String) -> String {
        return name.lowercased()
    }
}
