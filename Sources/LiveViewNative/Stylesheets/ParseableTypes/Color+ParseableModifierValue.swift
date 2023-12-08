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
        OneOf {
            CustomColor.parser(in: context).map(\.value)
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
    }
    
    @ParseableExpression
    struct CustomColor {
        static let name = "Color"
        
        let value: Color
        
        init(_ name: String) {
            self.value = .init(name, bundle: nil)
        }
        
        public init(_ colorSpace: Color.RGBColorSpace = .sRGB, red: Double, green: Double, blue: Double, opacity: Double = 1) {
            self.value = .init(colorSpace, red: red, green: green, blue: blue, opacity: opacity)
        }
        public init(_ colorSpace: Color.RGBColorSpace = .sRGB, white: Double, opacity: Double = 1) {
            self.value = .init(colorSpace, white: white, opacity: opacity)
        }
        public init(hue: Double, saturation: Double, brightness: Double, opacity: Double = 1) {
            self.value = .init(hue: hue, saturation: saturation, brightness: brightness, opacity: opacity)
        }
    }
    
    static func baseParser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            ImplicitStaticMember([
                "red": .red,
                "orange": .orange,
                "yellow": .yellow,
                "green": .green,
                "mint": .mint,
                "teal": .teal,
                "cyan": .cyan,
                "blue": .blue,
                "indigo": .indigo,
                "purple": .purple,
                "pink": .pink,
                "brown": .brown,
                "white": .white,
                "gray": .gray,
                "black": .black,
                "clear": .clear,
                "primary": .primary,
                "secondary": .secondary,
            ])
            
            CustomColor.parser(in: context).map(\.value)
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

extension SwiftUI.Color.RGBColorSpace: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember([
            "sRGB": .sRGB,
            "sRGBLinear": .sRGBLinear,
            "displayP3": .displayP3,
        ])
    }
}
