//
//  PresentationDetent+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 11/21/23.
//

import SwiftUI
import LiveViewNativeStylesheet

extension PresentationDetent: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
                ConstantAtomLiteral("large").map({ Self.large })
                ConstantAtomLiteral("medium").map({ Self.medium })
                Fraction.parser(in: context).map({ Self.fraction($0.fraction) })
                Height.parser(in: context).map({ Self.height($0.height) })
            }
        }
    }
    
    @ParseableExpression
    struct Fraction {
        static let name = "fraction"
        
        let fraction: CGFloat
        
        init(_ fraction: CGFloat) {
            self.fraction = fraction
        }
    }
    
    @ParseableExpression
    struct Height {
        static let name = "height"
        
        let height: CGFloat
        
        init(_ height: CGFloat) {
            self.height = height
        }
    }
}
