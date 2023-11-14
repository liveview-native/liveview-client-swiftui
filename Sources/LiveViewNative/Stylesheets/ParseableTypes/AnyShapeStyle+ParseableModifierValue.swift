//
//  AnyShapeStyle+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 10/17/23.
//

import SwiftUI
import LiveViewNativeStylesheet

extension AnyShapeStyle: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ChainedMemberExpression {
            baseParser(in: context)
        } member: {
            StyleModifier.parser(in: context)
        }
        .map({ (base: any ShapeStyle, modifiers: [StyleModifier]) in
            var result = base
            for modifier in modifiers {
                result = modifier.apply(to: result)
            }
            return AnyShapeStyle(result)
        })
    }
    
    static func baseParser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, any ShapeStyle> {
        OneOf {
            HierarchicalShapeStyle.parser(in: context).map({ $0 as any ShapeStyle })
            SwiftUI.Color.baseParser(in: context).map({ $0 as any ShapeStyle })
        }
    }
    
    enum StyleModifier: ParseableModifierValue {
        case opacity(Opacity)
        
        static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
            OneOf {
                Opacity.parser(in: context).map(Self.opacity)
            }
        }
        
        @ParseableExpression
        struct Opacity {
            static let name = "opacity"
            
            let value: Double
            
            init(_ value: Double) {
                self.value = value
            }
        }
        
        func apply(to style: some ShapeStyle) -> any ShapeStyle {
            switch self {
            case let .opacity(opacity):
                style.opacity(opacity.value)
            }
        }
    }
}

extension HierarchicalShapeStyle: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            ConstantAtomLiteral("primary").map({ .primary })
            ConstantAtomLiteral("secondary").map({ .secondary })
            ConstantAtomLiteral("tertiary").map({ .tertiary })
            ConstantAtomLiteral("quaternary").map({ .quaternary })
            if #available(tvOS 17, watchOS 10, *) {
                ConstantAtomLiteral("quinary").map({ .quinary })
            }
        }
    }
}
