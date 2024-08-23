//
//  TextInputAutocapitalization+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 10/26/23.
//

import SwiftUI
import LiveViewNativeStylesheet

#if !os(macOS)
/// See [`SwiftUI.TextInputAutocapitalization`](https://developer.apple.com/documentation/swiftui/TextInputAutocapitalization) for more details.
///
/// Possible values:
/// - `.never`
/// - `.words`
/// - `.sentences`
/// - `.characters`
@_documentation(visibility: public)
extension TextInputAutocapitalization: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember([
            "never": .never,
            "words": .words,
            "sentences": .sentences,
            "characters": .characters,
        ])
    }
}
#endif
