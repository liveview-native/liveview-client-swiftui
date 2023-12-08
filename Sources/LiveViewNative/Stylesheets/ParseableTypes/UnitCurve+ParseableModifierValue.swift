//
//  UnitCurve+ParseableModifierValue.swift
//  
//
//  Created by Carson Katri on 12/4/23.
//

import SwiftUI
import LiveViewNativeStylesheet

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension UnitCurve: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ChainedMemberExpression {
            OneOf {
                ConstantAtomLiteral("easeInOut").map({ Self.easeInOut })
                ConstantAtomLiteral("easeIn").map({ Self.easeIn })
                ConstantAtomLiteral("easeOut").map({ Self.easeOut })
                ConstantAtomLiteral("circularEaseIn").map({ Self.circularEaseIn })
                ConstantAtomLiteral("circularEaseOut").map({ Self.circularEaseOut })
                ConstantAtomLiteral("circularEaseInOut").map({ Self.circularEaseInOut })
                ConstantAtomLiteral("linear").map({ Self.linear })
                Bezier.parser(in: context).map(\.value)
            }
        } member: {
            OneOf {
                ConstantAtomLiteral("inverse").map({ Modifier.inverse })
            }
        }
        .map { (base, members) in
            return members.reduce(into: base) { curve, member in
                curve = member.apply(to: curve)
            }
        }
    }
    
    @ParseableExpression
    struct Bezier {
        static let name = "bezier"
        
        let value: UnitCurve
        
        init(startControlPoint: UnitPoint, endControlPoint: UnitPoint) {
            self.value = .bezier(startControlPoint: startControlPoint, endControlPoint: endControlPoint)
        }
    }
    
    enum Modifier {
        case inverse
        
        func apply(to curve: UnitCurve) -> UnitCurve {
            switch self {
            case .inverse:
                return curve.inverse
            }
        }
    }
}
