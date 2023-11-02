//
//  ContentMode+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 11/2/23.
//
import SwiftUI
import LiveViewNativeStylesheet

extension ContentMode: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember([
            "fill": .fill,
            "fit": .fit,
        ])
    }
}
