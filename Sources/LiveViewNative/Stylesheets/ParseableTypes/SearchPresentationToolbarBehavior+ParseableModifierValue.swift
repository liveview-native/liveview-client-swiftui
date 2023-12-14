//
//  SearchPresentationToolbarBehavior+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 12/12/23.
//

import SwiftUI
import LiveViewNativeStylesheet

@available(iOS 17.1, macOS 14.1, tvOS 17.1, watchOS 10.1, *)
extension SearchPresentationToolbarBehavior: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember([
            "automatic": Self.automatic,
            "avoidHidingContext": Self.avoidHidingContent
        ])
    }
}
