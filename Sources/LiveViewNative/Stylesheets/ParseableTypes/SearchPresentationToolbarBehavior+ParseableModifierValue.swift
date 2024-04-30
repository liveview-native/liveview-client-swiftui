//
//  SearchPresentationToolbarBehavior+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 12/12/23.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.SearchPresentationToolbarBehavior`](https://developer.apple.com/documentation/swiftui/SearchPresentationToolbarBehavior) for more details.
///
/// Possible values:
/// - `.automatic`
/// - `.avoidHidingContext`
@_documentation(visibility: public)
@available(iOS 17.1, macOS 14.1, tvOS 17.1, watchOS 10.1, *)
extension SearchPresentationToolbarBehavior: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember([
            "automatic": Self.automatic,
            "avoidHidingContext": Self.avoidHidingContent
        ])
    }
}
