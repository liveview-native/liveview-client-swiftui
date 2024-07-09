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
/// See [`SwiftUI.View/matchedGeometryEffect(id:in:properties:anchor:isSource:)`](https://developer.apple.com/documentation/swiftui/view/matchedGeometryEffect(id:in:properties:anchor:isSource:)) for more details on this ViewModifier.
///
/// ### matchedGeometryEffect(id:in:properties:anchor:isSource:)
/// - `id`: `attr("...")` or ``Swift/String`` (required)
/// - `in`: `attr("...")` or ``Swift/String`` (required)
/// - `properties`: ``SwiftUI/MatchedGeometryProperties``
/// - `anchor`: ``SwiftUI/UnitPoint``
/// - `isSource`: `attr("...")` or ``Swift/Bool``
///
/// See [`SwiftUI.View/matchedGeometryEffect(id:in:properties:anchor:isSource:)`](https://developer.apple.com/documentation/swiftui/view/matchedGeometryEffect(id:in:properties:anchor:isSource:)) for more details on this ViewModifier.
///
/// Example:
///
/// ```heex
/// <Element style='matchedGeometryEffect(id: attr("id"), in: attr("namespace"), properties: .frame, anchor: .center, isSource: attr("isSource"))' id={@id} namespace={@namespace} isSource={@isSource} />
/// ```
@_documentation(visibility: public)
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

