//
//  SearchScopesModifier.swift
//
//
//  Created by Carson Katri on 11/22/23.
//

import SwiftUI
import LiveViewNativeStylesheet

// manual implementation
// Last argument has no label in iOS 16.4, which is incompatible with the stylesheet format.
@ParseableExpression
struct _SearchScopesModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "searchScopes" }
    
    @ChangeTracked private var scope: String
    
    let activation: Any?
    let scopes: ViewReference
    
    @ObservedElement private var element
    @LiveContext<R> private var context
    
    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS)
    @available(iOS 16.4, macOS 13.3, tvOS 16.4, *)
    init(_ scope: ChangeTracked<String>, activation: SearchScopeActivation, scopes: ViewReference) {
        self._scope = scope
        self.activation = activation
        self.scopes = scopes
    }
    
    init(_ scope: ChangeTracked<String>, scopes: ViewReference) {
        self._scope = scope
        self.activation = nil
        self.scopes = scopes
    }
    #endif
    
    func body(content: Content) -> some View {
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS)
        if #available(iOS 16.4, macOS 13.3, tvOS 16.4, *) {
            if let activation = activation as? SearchScopeActivation {
                content.searchScopes($scope, activation: activation, { scopes.resolve(on: element, in: context) })
            } else {
                content.searchScopes($scope, scopes: { scopes.resolve(on: element, in: context) })
            }
        } else if #available(iOS 16.0, macOS 13.0, tvOS 16.4, *) {
            content.searchScopes($scope, scopes: { scopes.resolve(on: element, in: context) })
        } else {
            content
        }
        #else
        content
        #endif
    }
}
