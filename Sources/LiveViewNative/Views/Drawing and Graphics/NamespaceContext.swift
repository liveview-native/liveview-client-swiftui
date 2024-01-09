//
//  NamespaceContext.swift
//
//
//  Created by Carson Katri on 4/3/23.
//

import SwiftUI

/// Creates a namespace for child elements to use.
///
/// Used with ``MatchedGeometryEffectModifier`` to create a namespace.
/// The ``id`` specified can be passed into ``MatchedGeometryEffectModifier/namespace`` on a child of this element.
///
/// ## Attributes
/// * ``id``
@_documentation(visibility: public)
struct NamespaceContext<R: RootRegistry>: View {
    @ObservedElement private var element
    @LiveContext<R> private var context
    
    /// The unique identifier for this namespace.
    @_documentation(visibility: public)
    @Attribute("id") private var id: String
    
    @Namespace private var namespace
    @Environment(\.namespaces) private var namespaces
    
    #if !os(iOS)
    @Environment(\.resetFocus) private var resetFocus
    #endif
    
    var body: some View {
        context.buildChildren(of: element)
            .environment(\.namespaces, namespaces.merging([id: namespace], uniquingKeysWith: { $1 }))
            #if !os(iOS)
            .onReceive(context.coordinator.receiveEvent("reset_focus")) { event in
                guard let namespace = event["namespace"] as? String,
                      namespace == id
                else { return }
                resetFocus(in: self.namespace)
            }
            #endif
    }
}

extension EnvironmentValues {
    private enum NamespacesKey: EnvironmentKey {
        static let defaultValue = [String:Namespace.ID]()
    }
    
    var namespaces: [String:Namespace.ID] {
        get { self[NamespacesKey.self] }
        set { self[NamespacesKey.self] = newValue }
    }
}
