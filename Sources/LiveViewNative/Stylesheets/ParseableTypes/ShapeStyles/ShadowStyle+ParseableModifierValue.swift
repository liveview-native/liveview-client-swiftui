//
//  ShadowStyle+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 1/18/24.
//

import SwiftUI
import LiveViewNativeStylesheet

extension ShadowStyle: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
                _drop.parser(in: context).map(\.value)
                _inner.parser(in: context).map(\.value)
            }
        }
    }
    
    @ParseableExpression
    struct _drop {
        static let name = "drop"
        
        let value: ShadowStyle
        
        init(color: Color = .init(.sRGBLinear, white: 0, opacity: 0.33), radius: CGFloat, x: CGFloat = 0, y: CGFloat = 0) {
            self.value = .drop(color: color, radius: radius, x: x, y: y)
        }
    }
    
    @ParseableExpression
    struct _inner {
        static let name = "inner"
        
        let value: ShadowStyle
        
        init(color: Color = .init(.sRGBLinear, white: 0, opacity: 0.55), radius: CGFloat, x: CGFloat = 0, y: CGFloat = 0) {
            self.value = .inner(color: color, radius: radius, x: x, y: y)
        }
    }
}
