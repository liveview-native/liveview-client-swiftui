//
//  KeyboardShortcut+Localization+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 11/22/23.
//

import SwiftUI
import LiveViewNativeStylesheet

extension KeyboardShortcut.Localization: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember([
            "automatic": .automatic,
            "withoutMirroring": .withoutMirroring,
            "custom": .custom,
        ])
    }
}
