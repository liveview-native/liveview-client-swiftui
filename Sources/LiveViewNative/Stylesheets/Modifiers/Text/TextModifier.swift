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
    func apply<R: RootRegistry>(to text: SwiftUI.Text, on element: ElementNode, in context: LiveContext<R>) -> SwiftUI.Text
}

/// A type-erased `TextModifier`, which can be applied to a `View` or directly on `Text`.
enum _AnyTextModifier<Root: RootRegistry>: ViewModifier, TextModifier, ParseableModifierValue {
    case font(_FontModifier<Root>)
    case fontWeight(_FontWeightModifier<Root>)
    case fontDesign(_FontDesignModifier<Root>)
    case fontWidth(_FontWidthModifier<Root>)
    case foregroundStyle(_ForegroundStyleModifier<Root>)
    case bold(_BoldModifier<Root>)
    case italic(_ItalicModifier<Root>)
    case strikethrough(_StrikethroughModifier<Root>)
    case underline(_UnderlineModifier<Root>)
    case monospaced(_MonospacedModifier<Root>)
    case monospacedDigit(_MonospacedDigitModifier<Root>)
    case kerning(_KerningModifier<Root>)
    case tracking(_TrackingModifier<Root>)
    case baselineOffset(_BaselineOffsetModifier<Root>)
    case textScale(_TextScaleModifier<Root>)
    
    func body(content: Content) -> some View {
        switch self {
        case let .foregroundStyle(modifier):
            content.modifier(modifier)
        case let .font(modifier):
            content.modifier(modifier)
        case let .fontWeight(modifier):
            content.modifier(modifier)
        case let .fontDesign(modifier):
            content.modifier(modifier)
        case let .fontWidth(modifier):
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
    
    func apply<R: RootRegistry>(to text: SwiftUI.Text, on element: ElementNode, in context: LiveContext<R>) -> SwiftUI.Text {
        switch self {
        case let .font(modifier):
            return modifier.apply(to: text, on: element, in: context)
        case let .fontWeight(modifier):
            return modifier.apply(to: text, on: element, in: context)
        case let .fontDesign(modifier):
            return modifier.apply(to: text, on: element, in: context)
        case let .fontWidth(modifier):
            return modifier.apply(to: text, on: element, in: context)
        case let .foregroundStyle(modifier):
            return modifier.apply(to: text, on: element, in: context)
        case let .bold(modifier):
            return modifier.apply(to: text, on: element, in: context)
        case let .italic(modifier):
            return modifier.apply(to: text, on: element, in: context)
        case let .strikethrough(modifier):
            return modifier.apply(to: text, on: element, in: context)
        case let .underline(modifier):
            return modifier.apply(to: text, on: element, in: context)
        case let .monospaced(modifier):
            return modifier.apply(to: text, on: element, in: context)
        case let .monospacedDigit(modifier):
            return modifier.apply(to: text, on: element, in: context)
        case let .kerning(modifier):
            return modifier.apply(to: text, on: element, in: context)
        case let .tracking(modifier):
            return modifier.apply(to: text, on: element, in: context)
        case let .baselineOffset(modifier):
            return modifier.apply(to: text, on: element, in: context)
        case let .textScale(modifier):
            return modifier.apply(to: text, on: element, in: context)
        }
    }
    
    static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            _FontModifier<Root>.parser(in: context).map(Self.font)
            _FontWeightModifier<Root>.parser(in: context).map(Self.fontWeight)
            _FontDesignModifier<Root>.parser(in: context).map(Self.fontDesign)
            _FontWidthModifier<Root>.parser(in: context).map(Self.fontWidth)
            _ForegroundStyleModifier<Root>.parser(in: context).map(Self.foregroundStyle)
            _BoldModifier<Root>.parser(in: context).map(Self.bold)
            _ItalicModifier<Root>.parser(in: context).map(Self.italic)
            _StrikethroughModifier<Root>.parser(in: context).map(Self.strikethrough)
            _UnderlineModifier<Root>.parser(in: context).map(Self.underline)
            _MonospacedModifier<Root>.parser(in: context).map(Self.monospaced)
            _MonospacedDigitModifier<Root>.parser(in: context).map(Self.monospacedDigit)
            _KerningModifier<Root>.parser(in: context).map(Self.kerning)
            _TrackingModifier<Root>.parser(in: context).map(Self.tracking)
            _BaselineOffsetModifier<Root>.parser(in: context).map(Self.baselineOffset)
            _TextScaleModifier<Root>.parser(in: context).map(Self.textScale)
        }
    }
}
