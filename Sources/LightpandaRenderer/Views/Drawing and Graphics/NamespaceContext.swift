//
//  NamespaceContext.swift
//
//
//  Created by Carson Katri on 4/3/23.
//

import SwiftUI
import LightpandaClient

/// Creates a namespace for child elements to use.
///
/// Used with ``MatchedGeometryEffectModifier`` to create a namespace.
/// The ``id`` specified can be passed into ``MatchedGeometryEffectModifier/namespace`` on a child of this element.
///
/// ## Attributes
/// * ``id``
@_documentation(visibility: public)
struct NamespaceContext<Library: ElementLibrary>: View {
    let node: Node
    
    /// The unique identifier for this namespace.
    @_documentation(visibility: public)
    private var id: String? {
        node.attributeValue(for: "id")
    }
    
    @Namespace private var namespace
    
    @Environment(\.namespaces) private var namespaces
    
    #if !os(iOS) && !os(visionOS)
    @Environment(\.resetFocus) private var resetFocus
    
    struct ResetFocusEvent: Decodable {
        let namespace: String
    }
    #endif
    
    var body: some View {
        if let id {
            node.children(library: Library.self)
                .environment(\.namespaces, namespaces.merging([id: namespace], uniquingKeysWith: { $1 }))
                #if !os(iOS) && !os(visionOS)
                .onReceive($liveElement.context.coordinator.receiveEvent("reset_focus")) { (event: ResetFocusEvent) in
                    guard event.namespace == id
                    else { return }
                    resetFocus(in: self.namespace)
                }
                #endif
        } else {
            node.children(library: Library.self)
        }
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
