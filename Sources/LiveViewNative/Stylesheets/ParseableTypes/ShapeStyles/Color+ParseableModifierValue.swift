//
//  Color+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 10/18/23.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.Color`](https://developer.apple.com/documentation/swiftui/Color) for more details.
///
/// System Colors:
/// - `.red`
/// - `.orange`
/// - `.yellow`
/// - `.green`
/// - `.mint`
/// - `.teal`
/// - `.cyan`
/// - `.blue`
/// - `.indigo`
/// - `.purple`
/// - `.pink`
/// - `.brown`
/// - `.white`
/// - `.gray`
/// - `.black`
/// - `.clear`
/// - `.primary`
/// - `.secondary`
///
/// ### Named Colors
/// Get a custom color from the asset catalog by name.
///
/// ```swift
/// Color("MyColor")
/// ```
///
/// ### RGB Colors
/// Optionally provide the ``SwiftUI/Color/RGBColorSpace``.
///
/// ```swift
/// Color(red: 1, green: 0.5, blue: 0.5)
/// Color(red: 1, green: 0, blue: 0, opacity: 0.5)
/// Color(.displayP3, red: 0, green: 1, blue: 0)
/// Color(white: 0.5, opacity: 1)
/// ```
///
/// ### HSB Colors
/// Use `hue`, `saturation`, `brightness`, and `opacity` to create a color.
///
/// ```swift
/// Color(hue: 0.5, saturation: 1, brightness: 0.5)
/// Color(hue: 0, saturation: 0.5, brightness: 1, opacity: 0.5)
/// ```
///
/// ### Setting Opacity
/// Use the `opacity` modifier to customize the appearance of a color.
///
/// ```swift
/// .red.opacity(0.5)
/// Color("MyColor").opacity(0.8)
/// ```
@_documentation(visibility: public)
extension SwiftUI.Color: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        _ColorParser(context: context) {}
            .map(\.base)
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
    
    static var systemColors: [String:Color] {
        [
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
        ]
    }
    
    static func baseParser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        return OneOf {
            MemberExpression {
                ConstantAtomLiteral("Color")
            } member: {
                EnumParser(systemColors)
            }
            .map(\.member)
            
            ImplicitStaticMember(systemColors)
            
            CustomColor.parser(in: context).map(\.value)
        }
    }
    
    static func modifierParser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, ColorModifier> {
        OneOf {
            ColorModifier.Opacity.parser(in: context).map(ColorModifier.opacity)
        }
    }
}

struct _ColorParser<Members: Parser>: Parser where Members.Input == Substring.UTF8View {
    let context: ParseableModifierContext
    @ParserBuilder<Substring.UTF8View> let members: Members
    
    var body: some Parser<Substring.UTF8View, (base: SwiftUI.Color, members: [Members.Output])> {
        OneOf {
            MemberExpression {
                OneOf {
                    ConstantAtomLiteral("Color")
                    NilLiteral()
                }
            } member: {
                ChainedMemberExpression {
                    EnumParser(Color.systemColors)
                } member: {
                    OneOf {
                        Color.modifierParser(in: context).map(AnyColorModifier.colorModifier)
                        members.map(AnyColorModifier.member)
                    }
                }
                .map { base, modifiers -> (base: SwiftUI.Color, members: [Members.Output]) in
                    let colorModifiers: [ColorModifier] = modifiers
                        .compactMap({
                            guard case let .colorModifier(modifier) = $0 else { return nil }
                            return modifier
                        })
                    let members: [Members.Output] = modifiers
                        .compactMap({
                            guard case let .member(member) = $0 else { return nil }
                            return member
                        })
                    let color = colorModifiers.reduce(into: base) {
                        $0 = $1.apply(to: $0)
                    }
                    return (base: color, members: members)
                }
            }
            .map(\.member)

            ChainedMemberExpression {
                Color.baseParser(in: context)
            } member: {
                OneOf {
                    Color.modifierParser(in: context).map(AnyColorModifier.colorModifier)
                    members.map(AnyColorModifier.member)
                }
            }
            .map { base, modifiers -> (base: SwiftUI.Color, members: [Members.Output]) in
                let colorModifiers: [ColorModifier] = modifiers
                    .compactMap({
                        guard case let .colorModifier(modifier) = $0 else { return nil }
                        return modifier
                    })
                let members: [Members.Output] = modifiers
                    .compactMap({
                        guard case let .member(member) = $0 else { return nil }
                        return member
                    })
                let color = colorModifiers.reduce(into: base) {
                    $0 = $1.apply(to: $0)
                }
                return (base: color, members: members)
            }
        }
    }
    
    private enum AnyColorModifier {
        case colorModifier(ColorModifier)
        case member(Members.Output)
    }
}

enum ColorModifier {
    case opacity(Opacity)
    
    @ParseableExpression
    struct Opacity {
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

/// See [`SwiftUI.Color.RGBColorSpace`](https://developer.apple.com/documentation/swiftui/Color/RGBColorSpace) for more details.
///
/// Possible values:
/// - `.sRGB`
/// - `.sRGBLinear`
/// - `.displayP3`
@_documentation(visibility: public)
extension SwiftUI.Color.RGBColorSpace: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember([
            "sRGB": .sRGB,
            "sRGBLinear": .sRGBLinear,
            "displayP3": .displayP3,
        ])
    }
}
