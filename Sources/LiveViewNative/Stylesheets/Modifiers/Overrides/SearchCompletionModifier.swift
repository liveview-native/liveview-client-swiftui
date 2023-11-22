//
//  SearchCompletionModifier.swift
//
//
//  Created by Carson Katri on 11/22/23.
//

import SwiftUI
import LiveViewNativeStylesheet

// manual implementation
// The `token` method requires a type conforming to `Identifiable`, which becomes ambiguous with `String`.
@ParseableExpression
struct _SearchCompletionModifier: ViewModifier {
    static let name = "searchCompletion"
    
    enum Completion {
        case completion(String)
        case token(Token)
    }
    let completion: Completion
    
    init(_ token: AtomString) {
        self.completion = .token(.init(id: token.value))
    }
    
    init(_ completion: String) {
        self.completion = .completion(completion)
    }
    
    func body(content: Content) -> some View {
        switch completion {
        case .completion(let string):
            content.searchCompletion(string)
        case .token(let token):
            content.searchCompletion(token)
        }
    }
    
    struct Token: Identifiable {
        let id: String
    }
}
