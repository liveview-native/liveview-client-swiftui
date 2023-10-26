//
//  TextAlignment.swift
//
//
//  Created by Carson Katri on 10/26/23.
//

import SwiftUI
import LiveViewNativeStylesheet

extension TextAlignment: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember([
            "leading": .leading,
            "center": .center,
            "trailing": .trailing,
        ])
    }
}
