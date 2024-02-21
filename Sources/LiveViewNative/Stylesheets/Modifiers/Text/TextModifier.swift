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

/// A type-erased `TextModifier`, which can be applied to a `View` or directly on `Text`.
enum _AnyTextModifier<R: RootRegistry>: ViewModifier, TextModifier, ParseableModifierValue {
    case font(_FontModifier<R>)
    case fontWeight(_FontWeightModifier<R>)
    case fontDesign(_FontDesignModifier<R>)
    case fontWidth(_FontWidthModifier<R>)
    case foregroundStyle(_ForegroundStyleModifier<R>)
    case bold(_BoldModifier<R>)
    case italic(_ItalicModifier<R>)
    case strikethrough(_StrikethroughModifier<R>)
    case underline(_UnderlineModifier<R>)
    case monospaced(_MonospacedModifier<R>)
    case monospacedDigit(_MonospacedDigitModifier<R>)
    case kerning(_KerningModifier<R>)
    case tracking(_TrackingModifier<R>)
    case baselineOffset(_BaselineOffsetModifier<R>)
    case textScale(_TextScaleModifier<R>)
    
    func body(content: Content) -> some View {
        switch self {
        case let .font(modifier):
            content.modifier(modifier)
        case let .fontWeight(modifier):
            content.modifier(modifier)
        case let .fontDesign(modifier):
            content.modifier(modifier)
        case let .fontWidth(modifier):
            content.modifier(modifier)
        case let .foregroundStyle(modifier):
            content.modifier(modifier)
        case let .bold(modifier):
            content.modifier(modifier)
        case let .italic(modifier):
            content.modifier(modifier)
        case let .strikethrough(modifier):
            content.modifier(modifier)
        case let .underline(modifier):
            content.modifier(modifier)
        case let .monospaced(modifier):
            content.modifier(modifier)
        case let .monospacedDigit(modifier):
            content.modifier(modifier)
        case let .kerning(modifier):
            content.modifier(modifier)
        case let .tracking(modifier):
            content.modifier(modifier)
        case let .baselineOffset(modifier):
            content.modifier(modifier)
        case let .textScale(modifier):
            content.modifier(modifier)
        }
    }
    
    func apply(to text: SwiftUI.Text, on element: ElementNode) -> SwiftUI.Text {
        switch self {
        case let .font(modifier):
            return modifier.apply(to: text, on: element)
        case let .fontWeight(modifier):
            return modifier.apply(to: text, on: element)
        case let .fontDesign(modifier):
            return modifier.apply(to: text, on: element)
        case let .fontWidth(modifier):
            return modifier.apply(to: text, on: element)
        case let .foregroundStyle(modifier):
            return modifier.apply(to: text, on: element)
        case let .bold(modifier):
            return modifier.apply(to: text, on: element)
        case let .italic(modifier):
            return modifier.apply(to: text, on: element)
        case let .strikethrough(modifier):
            return modifier.apply(to: text, on: element)
        case let .underline(modifier):
            return modifier.apply(to: text, on: element)
        case let .monospaced(modifier):
            return modifier.apply(to: text, on: element)
        case let .monospacedDigit(modifier):
            return modifier.apply(to: text, on: element)
        case let .kerning(modifier):
            return modifier.apply(to: text, on: element)
        case let .tracking(modifier):
            return modifier.apply(to: text, on: element)
        case let .baselineOffset(modifier):
            return modifier.apply(to: text, on: element)
        case let .textScale(modifier):
            return modifier.apply(to: text, on: element)
        }
    }
    
    static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            _FontModifier<R>.parser(in: context).map(Self.font)
            _FontWeightModifier<R>.parser(in: context).map(Self.fontWeight)
            _FontDesignModifier<R>.parser(in: context).map(Self.fontDesign)
            _FontWidthModifier<R>.parser(in: context).map(Self.fontWidth)
            _ForegroundStyleModifier<R>.parser(in: context).map(Self.foregroundStyle)
            _BoldModifier<R>.parser(in: context).map(Self.bold)
            _ItalicModifier<R>.parser(in: context).map(Self.italic)
            _StrikethroughModifier<R>.parser(in: context).map(Self.strikethrough)
            _UnderlineModifier<R>.parser(in: context).map(Self.underline)
            _MonospacedModifier<R>.parser(in: context).map(Self.monospaced)
            _MonospacedDigitModifier<R>.parser(in: context).map(Self.monospacedDigit)
            _KerningModifier<R>.parser(in: context).map(Self.kerning)
            _TrackingModifier<R>.parser(in: context).map(Self.tracking)
            _BaselineOffsetModifier<R>.parser(in: context).map(Self.baselineOffset)
            _TextScaleModifier<R>.parser(in: context).map(Self.textScale)
        }
    }
}
