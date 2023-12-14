//
//  KeyEquivalent+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 11/21/23.
//

import SwiftUI
import LiveViewNativeStylesheet

#if os(iOS) || os(macOS) || os(visionOS)
extension KeyEquivalent: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            ImplicitStaticMember([
                "upArrow": .upArrow,
                "downArrow": .downArrow,
                "leftArrow": .leftArrow,
                "rightArrow": .rightArrow,
                "clear": .clear,
                "delete": .delete,
                "end": .end,
                "escape": .escape,
                "home": .home,
                "pageUp": .pageUp,
                "pageDown": .pageDown,
                "return": .return,
                "space": .space,
                "tab": .tab,
            ])
            String.parser(in: context).compactMap(\.first).map(Self.init(_:))
        }
    }
}
#endif
