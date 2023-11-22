//
//  TextInputDictationBehavior+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 11/21/23.
//

import SwiftUI
import LiveViewNativeStylesheet

@available(iOS 17, *)
extension TextInputDictationBehavior: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
                "automatic".utf8.map({ Self.automatic })
                Inline.parser(in: context).map({ Self.inline(activation: $0.activation) })
                #if os(visionOS)
                if #available(visionOS 1.0, *) {
                    "preventDictation".utf8.map({ Self.preventDictation })
                }
                #endif
            }
        }
    }
    
    @ParseableExpression
    struct Inline {
        static let name = "inline"
        
        let activation: TextInputDictationActivation
        
        init(activation: TextInputDictationActivation) {
            self.activation = activation
        }
    }
}

@available(iOS 17, *)
extension TextInputDictationActivation: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember([
            "onLook": .onLook,
            "onSelect": .onSelect
        ])
    }
}
