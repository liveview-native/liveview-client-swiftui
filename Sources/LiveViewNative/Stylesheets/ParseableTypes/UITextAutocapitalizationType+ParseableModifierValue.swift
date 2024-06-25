//
//  UITextAutocapitalizationType+ParseableModifierValue.swift
//  
//
//  Created by Carson.Katri on 6/20/24.
//

import SwiftUI
import LiveViewNativeStylesheet

extension UITextAutocapitalizationType: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember([
            "none": Self.none,
            "sentences": Self.sentences,
            "words": Self.words,
            "allCharacters": Self.allCharacters,
        ])
    }
}
