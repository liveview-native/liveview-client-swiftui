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
struct _MatchedGeometryEffectModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "matchedGeometryEffect" }
    
    @Environment(\.namespaces) private var namespaces
    
    @ObservedElement private var element
    @LiveContext<R> private var context
    
    let id: AttributeReference<String>
    let namespace: AttributeReference<String>
    let properties: MatchedGeometryProperties
    let anchor: UnitPoint
    let isSource: AttributeReference<Bool>
    
    init(id: AttributeReference<String>, in namespace: AttributeReference<String>, properties: MatchedGeometryProperties = .frame, anchor: UnitPoint = .center, isSource: AttributeReference<Bool> = .init(storage: .constant(true))) {
        self.id = id
        self.namespace = namespace
        self.properties = properties
        self.anchor = anchor
        self.isSource = isSource
    }
    
    func body(content: Content) -> some View {
        content.matchedGeometryEffect(
            id: id.resolve(on: element, in: context),
            in: namespaces[namespace.resolve(on: element, in: context)]!,
            properties: properties,
            anchor: anchor,
            isSource: isSource.resolve(on: element, in: context)
        )
    }
}

