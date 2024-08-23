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
/// See [`SwiftUI.View/searchCompletion(_:)`](https://developer.apple.com/documentation/swiftui/view/searchCompletion(_:)-e0pr) for more details on this ViewModifier.
///
/// ### searchCompletion(_:)
/// - `token`: atom (required)
///
/// See [`SwiftUI.View/searchCompletion(_:)`](https://developer.apple.com/documentation/swiftui/view/searchCompletion(_:)-e0pr) for more details on this ViewModifier.
///
/// Example:
///
/// ```html
/// <Element style="searchCompletion(:token)" />
/// ```
///
/// ### searchCompletion(_:)
/// - `completion`: `attr("...")` or ``Swift/String`` (required)
///
/// See [`SwiftUI.View/searchCompletion(_:)`](https://developer.apple.com/documentation/swiftui/view/searchCompletion(_:)-2uaf3) for more details on this ViewModifier.
///
/// Example:
///
/// ```heex
/// <Element style='searchCompletion(attr("completion"))' completion={@completion} />
/// ```
@_documentation(visibility: public)
@ParseableExpression
struct _SearchCompletionModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "searchCompletion" }
    
    enum Completion {
        case completion(AttributeReference<String>)
        #if os(iOS) || os(macOS) || os(visionOS)
        case token(Token)
        #endif
    }
    let completion: Completion
    
    @ObservedElement private var element
    @LiveContext<R> private var context
    
    #if os(iOS) || os(macOS) || os(visionOS)
    init(_ token: AtomString) {
        self.completion = .token(.init(id: token.value))
    }
    #endif
    
    init(_ completion: AttributeReference<String>) {
        self.completion = .completion(completion)
    }
    
    func body(content: Content) -> some View {
        switch completion {
        case .completion(let string):
            content.searchCompletion(string.resolve(on: element, in: context))
        #if os(iOS) || os(macOS) || os(visionOS)
        case .token(let token):
            content.searchCompletion(token)
        #endif
        }
    }
    
    struct Token: Identifiable {
        let id: String
    }
}
