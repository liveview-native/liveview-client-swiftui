//
//  SearchSuggestionsPlacement+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 11/22/23.
//

import SwiftUI
import LiveViewNativeStylesheet

extension SearchSuggestionsPlacement.Set: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            ImplicitStaticMember([
                "menu": .menu,
                "content": .content,
            ])
            Array<Self>.parser(in: context).map({ Self.init($0) })
        }
    }
}
