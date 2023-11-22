//
//  ButtonBorderShape+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 11/21/23.
//

import SwiftUI
import LiveViewNativeStylesheet

extension ButtonBorderShape: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
                ConstantAtomLiteral("automatic").map({ Self.automatic })
                ConstantAtomLiteral("capsule").map({ Self.capsule })
                if #available(iOS 17.0, macOS 14.0, tvOS 16.4, watchOS 10.0, *) {
                    ConstantAtomLiteral("circle").map({ Self.circle })
                }
                RoundedRectangle.parser(in: context).map({ Self.roundedRectangle(radius: $0.radius) })
                ConstantAtomLiteral("roundedRectangle").map({ Self.roundedRectangle })
            }
        }
    }
    
    @ParseableExpression
    struct RoundedRectangle {
        static let name = "roundedRectangle"
        
        let radius: CGFloat
        
        init(radius: CGFloat) {
            self.radius = radius
        }
    }
}
