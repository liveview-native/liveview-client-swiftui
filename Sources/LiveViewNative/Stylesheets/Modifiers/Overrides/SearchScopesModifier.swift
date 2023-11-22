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
    
    @available(iOS 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
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
    
    func body(content: Content) -> some View {
        if #available(iOS 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *) {
            if let activation = activation as? SearchScopeActivation {
                content.searchScopes($scope, activation: activation, { scopes.resolve(on: element, in: context) })
            } else {
                content.searchScopes($scope, scopes: { scopes.resolve(on: element, in: context) })
            }
        } else {
            content.searchScopes($scope, scopes: { scopes.resolve(on: element, in: context) })
        }
    }
}