//
//  ImageScale+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 10/26/23.
//

import SwiftUI
import LiveViewNativeStylesheet

extension SwiftUI.Image.Scale: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember([
            "small": .small,
            "medium": .medium,
            "large": .large,
        ])
    }
}
