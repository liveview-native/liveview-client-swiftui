//
//  TextModifier.swift
//
//
//  Created by Carson Katri on 2/20/23.
//

import SwiftUI
import LiveViewNativeStylesheet

/// A `ViewModifier` that can be applied directly to `Text`.
protocol TextModifier: ViewModifier {
    func apply(to text: SwiftUI.Text, on element: ElementNode) -> SwiftUI.Text
}

// font, fontWeight, fontDesign, fontWidth, foregroundStyle, bold, italic, strikethrough, underline, monospaced, monospacedDigit, kerning, tracking, baselineOffset, textScale, typesettingLanguage, speechAdjustedPitch, speechAlwaysIncludesPunctuation, speechAnnouncementQueued, speechSpellsOutCharacters, accessibilityHeading, accessibilityLabel, accessibilityTextContentType

enum _AnyTextModifier<R: RootRegistry>: ViewModifier, TextModifier, ParseableModifierValue {
    case bold(_BoldModifier<R>)
    case italic(_ItalicModifier<R>)
    
    func body(content: Content) -> some View {
        switch self {
        case let .bold(modifier):
            content.modifier(modifier)
        case let .italic(modifier):
            content.modifier(modifier)
        }
    }
    
    func apply(to text: SwiftUI.Text, on element: ElementNode) -> SwiftUI.Text {
        switch self {
        case let .bold(modifier):
            return modifier.apply(to: text, on: element)
        case let .italic(modifier):
            return modifier.apply(to: text, on: element)
        }
    }
    
    static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            _BoldModifier<R>.parser(in: context).map(Self.bold)
            _ItalicModifier<R>.parser(in: context).map(Self.italic)
        }
    }
}
