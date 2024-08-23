//
//  Font+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 10/25/23.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.Font`](https://developer.apple.com/documentation/swiftui/Font) for more details.
///
/// Standard Fonts:
/// - `.largeTitle`
/// - `.title`
/// - `.title2`
/// - `.title3`
/// - `.headline`
/// - `.subheadline`
/// - `.body`
/// - `.callout`
/// - `.footnote`
/// - `.caption`
/// - `.caption2`
///
/// ### System Fonts
/// Create a system font with a custom `size`, ``SwiftUI/Font/Weight``, ``SwiftUI/Font/Design``, and ``SwiftUI/Font/TextStyle``.
///
/// ```swift
/// .system(size: 13)
/// .system(size: 17, weight: .heavy, design: .serif)
/// .system(.title2, design: .serif, weight: .heavy)
/// ```
///
/// ### Custom Fonts
/// Use a custom font name, with a `size` that is optionally relative to a ``SwiftUI/TextStyle``.
///
/// ```swift
/// .custom("MyFont", size: 10)
/// .custom("MyFont", size: 13, relativeTo: .title2)
/// .custom("MyFont", fixedSize: 17)
/// ```
///
/// ### Font Modifiers
/// Apply modifiers to a font to customize its appearance.
///
/// - `italic()`
/// - `smallCaps()`
/// - `lowercaseSmallCaps()`
/// - `uppercaseSmallCaps()`
/// - `monospacedDigit()`
/// - `weight(Font.Weight)`, with a ``SwiftUI/Weight``
/// - `width(Font.Width)`, with a ``SwiftUI/Width``
/// - `bold()`
/// - `monospaced()`
/// - `leading(Font.Leading)`, with a ``SwiftUI/Leading``
@_documentation(visibility: public)
extension Font: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ChainedMemberExpression {
            OneOf {
                System.parser(in: context).map(\.value)
                Custom.parser(in: context).map(\.value)
                EnumParser([
                    "largeTitle": .largeTitle,
                    "title": .title,
                    "title2": .title2,
                    "title3": .title3,
                    "headline": .headline,
                    "subheadline": .subheadline,
                    "body": .body,
                    "callout": .callout,
                    "footnote": .footnote,
                    "caption": .caption,
                    "caption2": .caption2,
                ])
            }
        } member: {
            FontMember.parser(in: context)
        }
        .map { base, members in
            members.reduce(base, { $1.apply(to: $0) })
        }
    }
    
    @ParseableExpression
    struct System {
        static let name = "system"
        
        let value: Font
        
        init(size: CGFloat, weight: Font.Weight? = nil, design: Font.Design? = nil) {
            self.value = .system(size: size, weight: weight, design: design)
        }
        
        init(_ style: Font.TextStyle, design: Font.Design? = nil, weight: Font.Weight? = nil) {
            self.value = .system(style, design: design, weight: weight)
        }
    }
    
    @ParseableExpression
    struct Custom {
        static let name = "custom"
        
        let value: Font
        
        init(_ name: String, size: CGFloat) {
            self.value = .custom(name, size: size)
        }
        
        init(_ name: String, size: CGFloat, relativeTo textStyle: Font.TextStyle) {
            self.value = .custom(name, size: size, relativeTo: textStyle)
        }
        
        init(_ name: String, fixedSize: CGFloat) {
            self.value = .custom(name, fixedSize: fixedSize)
        }
    }
    
    enum FontMember: ParseableModifierValue {
        case italic
        case smallCaps
        case lowercaseSmallCaps
        case uppercaseSmallCaps
        case monospacedDigit
        case weight(Font.Weight)
        case width(Font.Width)
        case bold
        case monospaced
        case leading(Font.Leading)
        
        func apply(to font: Font) -> Font {
            switch self {
            case .italic:
                font.italic()
            case .smallCaps:
                font.smallCaps()
            case .lowercaseSmallCaps:
                font.lowercaseSmallCaps()
            case .uppercaseSmallCaps:
                font.uppercaseSmallCaps()
            case .monospacedDigit:
                font.monospacedDigit()
            case .weight(let weight):
                font.weight(weight)
            case .width(let width):
                font.width(width)
            case .bold:
                font.bold()
            case .monospaced:
                font.monospaced()
            case .leading(let leading):
                font.leading(leading)
            }
        }
        
        static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
            OneOf {
                ASTNode("italic").map({ _ in Self.italic })
                ASTNode("smallCaps").map({ _ in Self.smallCaps })
                ASTNode("lowercaseSmallCaps").map({ _ in Self.lowercaseSmallCaps })
                ASTNode("uppercaseSmallCaps").map({ _ in Self.uppercaseSmallCaps })
                ASTNode("monospacedDigit").map({ _ in Self.monospacedDigit })
                WeightMember.parser(in: context).map({ Self.weight($0.weight) })
                WidthMember.parser(in: context).map({ Self.width($0.width) })
                ASTNode("bold").map({ _ in Self.bold })
                ASTNode("monospaced").map({ _ in Self.monospaced })
                LeadingMember.parser(in: context).map({ Self.leading($0.leading) })
            }
        }
        
        @ParseableExpression
        struct WeightMember {
            static let name = "weight"
            
            let weight: Font.Weight
            
            init(_ weight: Font.Weight) {
                self.weight = weight
            }
        }
        
        @ParseableExpression
        struct WidthMember {
            static let name = "width"
            
            let width: Font.Width
            
            init(_ width: Font.Width) {
                self.width = width
            }
        }
        
        @ParseableExpression
        struct LeadingMember {
            static let name = "leading"
            
            let leading: Font.Leading
            
            init(_ leading: Font.Leading) {
                self.leading = leading
            }
        }
    }
}

/// See [`SwiftUI.Font.Design`](https://developer.apple.com/documentation/swiftui/Font/Design) for more details.
///
/// Possible values:
/// - `.default`
/// - `.serif`
/// - `.rounded`
/// - `.monospaced`
@_documentation(visibility: public)
extension Font.Design: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember([
            "default": .`default`,
            "serif": .serif,
            "rounded": .rounded,
            "monospaced": .monospaced,
        ])
    }
}

/// See [`SwiftUI.Font.TextStyle`](https://developer.apple.com/documentation/swiftui/Font/TextStyle) for more details.
///
/// Possible values:
/// - `.largeTitle`
/// - `.title`
/// - `.title2`
/// - `.title3`
/// - `.headline`
/// - `.subheadline`
/// - `.body`
/// - `.callout`
/// - `.footnote`
/// - `.caption`
/// - `.caption2`
@_documentation(visibility: public)
extension Font.TextStyle: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember([
            "largeTitle": .largeTitle,
            "title": .title,
            "title2": .title2,
            "title3": .title3,
            "headline": .headline,
            "subheadline": .subheadline,
            "body": .body,
            "callout": .callout,
            "footnote": .footnote,
            "caption": .caption,
            "caption2": .caption2,
        ])
    }
}

/// See [`SwiftUI.Font.Weight`](https://developer.apple.com/documentation/swiftui/Font/Weight) for more details.
///
/// Possible values:
/// - `.ultraLight`
/// - `.thin`
/// - `.light`
/// - `.regular`
/// - `.medium`
/// - `.semibold`
/// - `.bold`
/// - `.heavy`
/// - `.black`
@_documentation(visibility: public)
extension Font.Weight: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember([
            "ultraLight": .ultraLight,
            "thin": .thin,
            "light": .light,
            "regular": .regular,
            "medium": .medium,
            "semibold": .semibold,
            "bold": .bold,
            "heavy": .heavy,
            "black": .black,
        ])
    }
}

/// See [`SwiftUI.Font.Width`](https://developer.apple.com/documentation/swiftui/Font/Width) for more details.
///
/// Possible values:
/// - `.compressed`
/// - `.condensed`
/// - `.standard`
/// - `.expanded`
@_documentation(visibility: public)
extension Font.Width: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            ImplicitStaticMember([
                "compressed": .compressed,
                "condensed": .condensed,
                "standard": .standard,
                "expanded": .expanded,
            ])
            CGFloat.parser(in: context).map(Self.init)
        }
    }
}

/// See [`SwiftUI.Font.Leading`](https://developer.apple.com/documentation/swiftui/Font/Leading) for more details.
///
/// Possible values:
/// - `.standard`
/// - `.tight`
/// - `.loose`
@_documentation(visibility: public)
extension Font.Leading: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember([
            "standard": .standard,
            "tight": .tight,
            "loose": .loose,
        ])
    }
}
