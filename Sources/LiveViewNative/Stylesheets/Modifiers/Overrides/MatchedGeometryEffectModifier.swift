//
//  _MatchedGeometryEffect.swift
//
//
//  Created by Carson Katri on 11/22/23.
//

import SwiftUI
import LiveViewNativeStylesheet

// manual implementation
// `Namespace.ID` is a special case, and needs to be accessed from the environment.
@ParseableExpression
struct _MatchedGeometryEffectModifier: ViewModifier {
    static let name = "matchedGeometryEffect"
    
    @Environment(\.namespaces) private var namespaces
    
    let id: String
    let namespace: String
    let properties: MatchedGeometryProperties
    let anchor: UnitPoint
    let isSource: Bool
    
    init(id: String, in namespace: String, properties: MatchedGeometryProperties = .frame, anchor: UnitPoint = .center, isSource: Bool = true) {
        self.id = id
        self.namespace = namespace
        self.properties = properties
        self.anchor = anchor
        self.isSource = isSource
    }
    
    func body(content: Content) -> some View {
        content.matchedGeometryEffect(
            id: id,
            in: namespaces[namespace]!,
            properties: properties,
            anchor: anchor,
            isSource: isSource
        )
    }
}

