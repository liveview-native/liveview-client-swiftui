//
//  ContentTransition+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 11/21/23.
//

import SwiftUI
import Symbols
import LiveViewNativeStylesheet

/// See [`SwiftUI.ContentTransition`](https://developer.apple.com/documentation/swiftui/ContentTransition) for more details.
///
/// Standard Content Transitions:
/// - `.identity`
/// - `.interpolate`
/// - `.opacity`
/// - `.numericText()`
/// - `.symbolEffect`
///
/// ### Numeric Text
/// Provide a `value` or `countsDown` to customize the transition applied to numeric text.
///
/// ```swift
/// .numericText(countsDown: true)
/// .numericText(value: 10)
/// ```
///
/// ### Symbol Effect
/// Use a specific ``AnySymbolEffect`` for this content.
///
/// ```swift
/// .symbolEffect(.bounce)
/// .symbolEffect(.pulse, options: .repeating)
/// ```
@_documentation(visibility: public)
extension ContentTransition: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
                ConstantAtomLiteral("identity").map({ Self.identity })
                ConstantAtomLiteral("interpolate").map({ Self.interpolate })
                ConstantAtomLiteral("opacity").map({ Self.opacity })
                NumericText.parser(in: context).map(\.value)
                if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
                    SymbolEffect.parser(in: context).map(\.value)
                    ConstantAtomLiteral("symbolEffect").map({ Self.symbolEffect })
                }
            }
        }
    }
    
    @ASTDecodable("numericText")
    struct NumericText {
        let value: ContentTransition
        
        init(countsDown: Bool = false) {
            self.value = .numericText(countsDown: countsDown)
        }
        
        @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
        init(value: Double) {
            self.value = .numericText(value: value)
        }
    }
    
    @ASTDecodable("symbolEffect")
    struct SymbolEffect {
        let value: ContentTransition
        
        @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
        init(_ effect: AnySymbolEffect, options: SymbolEffectOptions = .default) {
            self.value = .symbolEffect(effect, options: options)
        }
    }
}
