//
//  Anchor+Source+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 11/22/23.
//

import SwiftUI
import LiveViewNativeStylesheet

extension Anchor<CGRect>.Source: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
                ConstantAtomLiteral("bounds").map({ Self.bounds })
                Rect.parser(in: context).map({ Self.rect($0.r) })
            }
        }
    }
    
    @ParseableExpression
    struct Rect {
        static let name = "rect"
        let r: CGRect
        
        init(_ r: CGRect) {
            self.r = r
        }
    }
}
