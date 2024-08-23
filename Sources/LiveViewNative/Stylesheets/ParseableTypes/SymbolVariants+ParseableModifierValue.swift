//
//  SymbolVariants+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 11/21/23.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.SymbolVariants`](https://developer.apple.com/documentation/swiftui/SymbolVariants) for more details.
///
/// Possible values:
/// - `.none`
/// - `.circle`
/// - `.square`
/// - `.rectangle`
/// - `.fill`
/// - `.slash`
///
/// Variants can be chained to build more complex variants.
///
/// ```swift
/// .circle.fill
/// .fill.slash
/// ```
@_documentation(visibility: public)
extension SymbolVariants: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ChainedMemberExpression {
            OneOf {
                ConstantAtomLiteral("none").map({ Self.none })
                ConstantAtomLiteral("circle").map({ Self.circle })
                ConstantAtomLiteral("square").map({ Self.square })
                ConstantAtomLiteral("rectangle").map({ Self.rectangle })
                ConstantAtomLiteral("fill").map({ Self.fill })
                ConstantAtomLiteral("slash").map({ Self.slash })
            }
        } member: {
            OneOf {
                ConstantAtomLiteral("circle").map({ Member.circle })
                ConstantAtomLiteral("square").map({ Member.square })
                ConstantAtomLiteral("rectangle").map({ Member.rectangle })
                ConstantAtomLiteral("fill").map({ Member.fill })
                ConstantAtomLiteral("slash").map({ Member.slash })
            }
        }.map { base, members in
            return members.reduce(into: base) { result, member in
                switch member {
                case .circle:
                    result = result.circle
                case .square:
                    result = result.square
                case .rectangle:
                    result = result.rectangle
                case .fill:
                    result = result.fill
                case .slash:
                    result = result.slash
                }
            }
        }
    }
    
    enum Member {
        case circle
        case square
        case rectangle
        case fill
        case slash
    }
}
