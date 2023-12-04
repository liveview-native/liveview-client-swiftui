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
                "easeInOut".utf8.map({ Self.easeInOut })
                "easeIn".utf8.map({ Self.easeIn })
                "easeOut".utf8.map({ Self.easeOut })
                "circularEaseIn".utf8.map({ Self.circularEaseIn })
                "circularEaseOut".utf8.map({ Self.circularEaseOut })
                "circularEaseInOut".utf8.map({ Self.circularEaseInOut })
                "linear".utf8.map({ Self.linear })
                Bezier.parser(in: context).map(\.value)
            }
        } member: {
            OneOf {
                "inverse".utf8.map({ Modifier.inverse })
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
