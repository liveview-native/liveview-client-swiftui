//
//  ContentTransition+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 11/21/23.
//

import SwiftUI
import Symbols
import LiveViewNativeStylesheet

extension ContentTransition: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
                ConstantAtomLiteral("identity").map({ Self.identity })
                ConstantAtomLiteral("interpolate").map({ Self.interpolate })
                ConstantAtomLiteral("opacity").map({ Self.opacity })
                NumericText.parser(in: context).map(\.value)
                if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
                    ConstantAtomLiteral("symbolEffect").map({ Self.symbolEffect })
                }
            }
        }
    }
    
    @ParseableExpression
    struct NumericText {
        static let name = "numericText"
        
        let value: ContentTransition
        
        init(countsDown: Bool = false) {
            self.value = .numericText(countsDown: countsDown)
        }
        
        @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
        init(value: Double) {
            self.value = .numericText(value: value)
        }
    }
    
    @ParseableExpression
    struct SymbolEffect {
        static let name = "symbolEffect"
        
        let value: ContentTransition
        
        @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
        init(_ effect: AnySymbolEffect, options: SymbolEffectOptions = .default) {
            self.value = .symbolEffect(effect, options: options)
        }
    }
}
