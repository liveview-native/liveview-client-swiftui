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
            
            ConstantAtomLiteral("zero").map({ Self.zero })
            ConstantAtomLiteral("center").map({ Self.center })
            ConstantAtomLiteral("leading").map({ Self.leading })
            ConstantAtomLiteral("trailing").map({ Self.trailing })
            ConstantAtomLiteral("top").map({ Self.top })
            ConstantAtomLiteral("bottom").map({ Self.bottom })
            ConstantAtomLiteral("topLeading").map({ Self.topLeading })
            ConstantAtomLiteral("topTrailing").map({ Self.topTrailing })
            ConstantAtomLiteral("bottomLeading").map({ Self.bottomLeading })
            ConstantAtomLiteral("bottomTrailing").map({ Self.bottomTrailing })
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
