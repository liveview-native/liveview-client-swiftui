//
//  UnitCurve+ParseableModifierValue.swift
//  
//
//  Created by Carson Katri on 12/4/23.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.UnitCurve`](https://developer.apple.com/documentation/swiftui/UnitCurve) for more details.
///
/// Possible values:
/// - `.easeInOut`
/// - `.easeIn`
/// - `.easeOut`
/// - `.circularEaseIn`
/// - `.circularEaseOut`
/// - `.circularEaseInOut`
/// - `.linear`
/// - `.bezier(startControlPoint:endControlPoint:)`
///
/// Apply `.inverse` to invert the curve.
/// ```swift
/// .easeIn.inverse
/// ```
///
/// Use a ``SwiftUI/UnitPoint`` to specify the start/end points of a bezier curve.
/// ```swift
/// .bezier(startControlPoint: .topLeading, endControlPoint: .bottomTrailing)
/// ```
@_documentation(visibility: public)
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
    
    @ASTDecodable("bezier")
    struct Bezier {
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
