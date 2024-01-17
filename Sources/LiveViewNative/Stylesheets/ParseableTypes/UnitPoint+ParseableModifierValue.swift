//
//  UnitPoint+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 10/19/23.
//

import SwiftUI
import LiveViewNativeStylesheet

extension UnitPoint: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            ParseableUnitPoint.parser(in: context).map({ Self.init(x: $0.x, y: $0.y) })
            
            ImplicitStaticMember([
                "zero": Self.zero,
                "center": Self.center,
                "leading": Self.leading,
                "trailing": Self.trailing,
                "top": Self.top,
                "bottom": Self.bottom,
                "topLeading": Self.topLeading,
                "topTrailing": Self.topTrailing,
                "bottomLeading": Self.bottomLeading,
                "bottomTrailing": Self.bottomTrailing,
            ])
        }
    }
    
    @ParseableExpression
    struct ParseableUnitPoint {
        static let name = "UnitPoint"
        
        let x: CGFloat
        let y: CGFloat
        
        init(x: CGFloat, y: CGFloat) {
            self.x = x
            self.y = y
        }
    }
}
