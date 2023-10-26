//
//  DynamicTypeSize+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 10/25/23.
//
import SwiftUI
import LiveViewNativeStylesheet

extension DynamicTypeSize: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember([
            "xSmall": .xSmall,
            "small": .small,
            "medium": .medium,
            "large": .large,
            "xLarge": .xLarge,
            "xxLarge": .xxLarge,
            "xxxLarge": .xxxLarge,
            "accessibility1": .accessibility1,
            "accessibility2": .accessibility2,
            "accessibility3": .accessibility3,
            "accessibility4": .accessibility4,
            "accessibility5": .accessibility5,
        ])
    }
}
