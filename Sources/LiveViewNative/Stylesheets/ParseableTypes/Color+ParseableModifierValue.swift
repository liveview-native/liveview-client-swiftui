//
//  Color+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 10/18/23.
//

import SwiftUI
import LiveViewNativeStylesheet

extension SwiftUI.Color: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ChainedMemberExpression {
            baseParser(in: context)
        } member: {
            modifierParser(in: context)
        }
        .map({ base, modifiers in
            modifiers.reduce(into: base) {
                $0 = $1.apply(to: $0)
            }
        })
    }
    
    @ParseableExpression
    struct NamedColor {
        static let name = "init"
        
        let name: String
        
        init(_ name: String) {
            self.name = name
        }
    }
    
    static func baseParser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            ConstantAtomLiteral("red").map({ .red })
            ConstantAtomLiteral("orange").map({ .orange })
            ConstantAtomLiteral("yellow").map({ .yellow })
            ConstantAtomLiteral("green").map({ .green })
            ConstantAtomLiteral("mint").map({ .mint })
            ConstantAtomLiteral("teal").map({ .teal })
            ConstantAtomLiteral("cyan").map({ .cyan })
            ConstantAtomLiteral("blue").map({ .blue })
            ConstantAtomLiteral("indigo").map({ .indigo })
            ConstantAtomLiteral("purple").map({ .purple })
            ConstantAtomLiteral("pink").map({ .pink })
            ConstantAtomLiteral("brown").map({ .brown })
            ConstantAtomLiteral("white").map({ .white })
            ConstantAtomLiteral("gray").map({ .gray })
            ConstantAtomLiteral("black").map({ .black })
            ConstantAtomLiteral("clear").map({ .clear })
            ConstantAtomLiteral("primary").map({ .primary })
            ConstantAtomLiteral("secondary").map({ .secondary })
            
            NamedColor.parser(in: context).map({ Self.init($0.name, bundle: nil) })
        }
    }
    
    private static func modifierParser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, ColorModifier> {
        OneOf {
            ColorModifier.Opacity.parser(in: context).map(ColorModifier.opacity)
        }
    }
}

private enum ColorModifier {
    case opacity(Opacity)
    
    @ParseableExpression
    fileprivate struct Opacity {
        static let name = "opacity"
        
        let value: Double
        
        init(_ value: Double) {
            self.value = value
        }
    }
    
    func apply(to color: SwiftUI.Color) -> SwiftUI.Color {
        switch self {
        case let .opacity(opacity):
            return color.opacity(opacity.value)
        }
    }
}
