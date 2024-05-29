//
//  Color+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 10/18/23.
//

import SwiftUI
import LiveViewNativeStylesheet
import LiveViewNativeCore

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
public extension SwiftUI.Color {
    struct Resolvable: ParseableModifierValue {
        enum Storage {
            case reference(AttributeName)
            case constant(SwiftUI.Color)
            case named(AttributeReference<String>)
            case components(
                colorSpace: AttributeReference<Color.RGBColorSpace> = .init(storage: .constant(.sRGB)),
                red: AttributeReference<Double>,
                green: AttributeReference<Double>,
                blue: AttributeReference<Double>,
                opacity: AttributeReference<Double> = .init(storage: .constant(1))
            )
            case monochrome(
                colorSpace: AttributeReference<Color.RGBColorSpace> = .init(storage: .constant(.sRGB)),
                white: AttributeReference<Double>,
                opacity: AttributeReference<Double> = .init(storage: .constant(1))
            )
            case hsb(
                hue: AttributeReference<Double>,
                saturation: AttributeReference<Double>,
                brightness: AttributeReference<Double>,
                opacity: AttributeReference<Double> = .init(storage: .constant(1))
            )
        }
        
        let storage: Storage
        let modifiers: [ColorModifier]
        
        public init(_ constant: SwiftUI.Color) {
            self.storage = .constant(constant)
            self.modifiers = []
        }
        
        init(storage: Storage, modifiers: [ColorModifier]) {
            self.storage = storage
            self.modifiers = modifiers
        }
        
        public func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> SwiftUI.Color {
            resolve(on: element)
        }
        
        public func resolve(on element: ElementNode) -> SwiftUI.Color {
            let base = switch storage {
            case let .reference(name):
                try! element.attributeValue(SwiftUI.Color.self, for: name)
            case let .constant(constant):
                constant
            case let .named(name):
                SwiftUI.Color.init(name.resolve(on: element), bundle: nil)
            case let .components(colorSpace, red, green, blue, opacity):
                SwiftUI.Color(
                    colorSpace.resolve(on: element),
                    red: red.resolve(on: element),
                    green: green.resolve(on: element),
                    blue: blue.resolve(on: element),
                    opacity: opacity.resolve(on: element)
                )
            case let .monochrome(colorSpace, white, opacity):
                SwiftUI.Color(
                    colorSpace.resolve(on: element),
                    white: white.resolve(on: element),
                    opacity: opacity.resolve(on: element)
                )
            case let .hsb(hue, saturation, brightness, opacity):
                SwiftUI.Color(
                    hue: hue.resolve(on: element),
                    saturation: saturation.resolve(on: element),
                    brightness: brightness.resolve(on: element),
                    opacity: opacity.resolve(on: element)
                )
            }
            return modifiers.reduce(into: base) {
                $0 = $1.apply(to: $0, on: element)
            }
        }
        
        public var constant: SwiftUI.Color {
            switch storage {
            case .reference:
                Color.primary
            case let .constant(constant):
                constant
            case let .named(name):
                SwiftUI.Color.init(name.constant(default: ""), bundle: nil)
            case let .components(colorSpace, red, green, blue, opacity):
                SwiftUI.Color(
                    colorSpace.constant(default: .sRGB),
                    red: red.constant(default: 0),
                    green: green.constant(default: 0),
                    blue: blue.constant(default: 0),
                    opacity: opacity.constant(default: 1)
                )
            case let .monochrome(colorSpace, white, opacity):
                SwiftUI.Color(
                    colorSpace.constant(default: .sRGB),
                    white: white.constant(default: 0),
                    opacity: opacity.constant(default: 1)
                )
            case let .hsb(hue, saturation, brightness, opacity):
                SwiftUI.Color(
                    hue: hue.constant(default: 0),
                    saturation: saturation.constant(default: 0),
                    brightness: brightness.constant(default: 0),
                    opacity: opacity.constant(default: 1)
                )
            }
        }
        
        public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
            _ColorParser(context: context) {}
                .map(\.base)
        }
        
        @ParseableExpression
        struct CustomColor {
            static let name = "Color"
            
            let storage: Storage
            
            init(_ name: AttributeReference<String>) {
                self.storage = .named(name)
            }
            
            public init(
                _ colorSpace: AttributeReference<Color.RGBColorSpace> = .init(.sRGB),
                red: AttributeReference<Double>,
                green: AttributeReference<Double>,
                blue: AttributeReference<Double>,
                opacity: AttributeReference<Double> = .init(1)
            ) {
                self.storage = .components(colorSpace: colorSpace, red: red, green: green, blue: blue, opacity: opacity)
            }
            
            public init(
                _ colorSpace: AttributeReference<Color.RGBColorSpace> = .init(.sRGB),
                white: AttributeReference<Double>,
                opacity: AttributeReference<Double> = .init(1)
            ) {
                self.storage = .monochrome(colorSpace: colorSpace, white: white, opacity: opacity)
            }
            
            public init(
                hue: AttributeReference<Double>,
                saturation: AttributeReference<Double>,
                brightness: AttributeReference<Double>,
                opacity: AttributeReference<Double> = .init(1)
            ) {
                self.storage = .hsb(hue: hue, saturation: saturation, brightness: brightness, opacity: opacity)
            }
        }
        
        static var systemColors: [String:Self] {
            [
                "red": .init(.red),
                "orange": .init(.orange),
                "yellow": .init(.yellow),
                "green": .init(.green),
                "mint": .init(.mint),
                "teal": .init(.teal),
                "cyan": .init(.cyan),
                "blue": .init(.blue),
                "indigo": .init(.indigo),
                "purple": .init(.purple),
                "pink": .init(.pink),
                "brown": .init(.brown),
                "white": .init(.white),
                "gray": .init(.gray),
                "black": .init(.black),
                "clear": .init(.clear),
                "primary": .init(.primary),
                "secondary": .init(.secondary),
            ]
        }
        
        static func baseParser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
            return OneOf {
                AttributeName.parser(in: context).map({ Self(storage: .reference($0), modifiers: []) })
                
                MemberExpression {
                    ConstantAtomLiteral("Color")
                } member: {
                    EnumParser(systemColors)
                }
                .map(\.member)
                
                ImplicitStaticMember(systemColors)
                
                CustomColor.parser(in: context).map({ Self(storage: $0.storage, modifiers: []) })
            }
        }
        
        static func modifierParser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, ColorModifier> {
            OneOf {
                ColorModifier.Opacity.parser(in: context).map(ColorModifier.opacity)
            }
        }
    }
}

struct _ColorParser<Members: Parser>: Parser where Members.Input == Substring.UTF8View {
    let context: ParseableModifierContext
    @ParserBuilder<Substring.UTF8View> let members: Members
    
    var body: some Parser<Substring.UTF8View, (base: Color.Resolvable, members: [Members.Output])> {
        OneOf {
            MemberExpression {
                OneOf {
                    ConstantAtomLiteral("Color")
                    NilLiteral()
                }
            } member: {
                ChainedMemberExpression {
                    EnumParser(Color.Resolvable.systemColors)
                } member: {
                    OneOf {
                        Color.Resolvable.modifierParser(in: context).map(AnyColorModifier.colorModifier)
                        members.map(AnyColorModifier.member)
                    }
                }
                .map { base, modifiers -> (base: Color.Resolvable, members: [Members.Output]) in
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
                    return (base: .init(storage: base.storage, modifiers: base.modifiers + colorModifiers), members: members)
                }
            }
            .map(\.member)

            ChainedMemberExpression {
                Color.Resolvable.baseParser(in: context)
            } member: {
                OneOf {
                    Color.Resolvable.modifierParser(in: context).map(AnyColorModifier.colorModifier)
                    members.map(AnyColorModifier.member)
                }
            }
            .map { base, modifiers -> (base: Color.Resolvable, members: [Members.Output]) in
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
                return (base: .init(storage: base.storage, modifiers: base.modifiers + colorModifiers), members: members)
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
        
        let value: AttributeReference<Double>
        
        init(_ value: AttributeReference<Double>) {
            self.value = value
        }
    }
    
    func apply(to color: SwiftUI.Color, on element: ElementNode) -> SwiftUI.Color {
        switch self {
        case let .opacity(opacity):
            return color.opacity(opacity.value.resolve(on: element))
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
