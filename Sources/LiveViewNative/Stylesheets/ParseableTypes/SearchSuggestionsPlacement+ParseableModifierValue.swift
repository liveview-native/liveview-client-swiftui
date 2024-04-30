//
//  SearchSuggestionsPlacement+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 11/22/23.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.SearchSuggestionsPlacement.Set`](https://developer.apple.com/documentation/swiftui/SearchSuggestionsPlacement/Set) for more details.
///
/// Possible values:
/// - `.menu`
/// - `.content`
/// - Array of these values
@_documentation(visibility: public)
extension SearchSuggestionsPlacement.Set: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            ImplicitStaticMember([
                "menu": .menu,
                "content": .content,
            ])
            Array<SearchSuggestionsPlacement>.parser(in: context).map({
                Self.init($0.map {
                    switch $0 {
                    case .content:
                        return .content
                    case .menu:
                        return .menu
                    default:
                        return .init()
                    }
                })
            })
        }
    }
}
