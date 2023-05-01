//
//  Font.swift
//  
//
//  Created by Carson Katri on 4/5/23.
//

import SwiftUI

/// A font value.
///
/// Create a font with various options and modifiers.
///
/// ```elixir
/// {:system, :body}
/// {:system, :large_title, [weight: :bold]}
/// {:custom, "Didot", [size: 21], [:monospaced_digit]}
/// ```
///
/// ### System Fonts
/// Create a system font with a tuple where the first element is the `:system` atom, and the second is a text style.
///
/// ```elixir
/// {:system, :subheadline}
/// ```
///
/// See ``LiveViewNative/SwiftUI/Font/TextStyle`` for a list of possible text styles.
///
/// You can specify more arguments, such as the `design` and `weight`, in the third element.
///
/// ```elixir
/// {:system, :subheadline, [design: :serif, weight: :bold]}
/// ```
///
/// ### Custom Fonts
/// Fonts can be created by name as well.
///
/// - Precondition: `size` or `fixed_size` is a required option.
///
/// ```elixir
/// {:custom, "Didot", [size: 21]}
/// ```
///
/// A font with a `fixed_size` will not scale with the system's dynamic type settings.
///
/// ```elixir
/// {:custom, "Didot", [fixed_size: 21]}
/// ```
///
/// When you use `size`, it is implied that it scales with the `body` text style.
/// Use the `relative_to` option to change the style it corresponds with.
///
/// ```elixir
/// {:custom, "Didot", [size: 21, relative_to: :large_title]}
/// ```
///
/// See ``LiveViewNative/SwiftUI/Font/TextStyle`` for a list of possible styles.
///
/// ### Adding Modifiers
/// The last element in a font tuple is a list of modifiers.
///
/// ```elixir
/// {:system, :subheadline, [], [:monospaced_digit, {:leading, :loose}]}
/// ```
///
/// Here, we apply the `monospaced_digit` and `leading` modifiers.
/// The `leading` modifier takes an argument, so it is created with a tuple where the second element is the value.
///
/// Many modifiers are available:
/// * `:bold`
/// * `:italic`
/// * `:monospaced`
/// * `:monospaced_digit`
/// * `:small_caps`
/// * `:lowercase_small_caps`
/// * `:uppercase_small_caps`
/// * `{:weight, <font weight>}` - See ``LiveViewNative/SwiftUI/Font/Weight`` for a list of possible weights
/// * `{:width, <font width>}` - See ``LiveViewNative/SwiftUI/Font/Width`` for a list of possible widths
/// * `{:leading, <font leading>}` - See ``LiveViewNative/SwiftUI/Font/Leading`` for a list of possible leading values
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
extension Font: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var base: Font
        switch try container.decode(FontType.self, forKey: .type) {
        case .system:
            let properties = try container.nestedContainer(keyedBy: CodingKeys.System.self, forKey: .properties)
            if let style = try properties.decodeIfPresent(TextStyle.self, forKey: .style) {
                base = .system(
                    style,
                    design: try properties.decodeIfPresent(Design.self, forKey: .design),
                    weight: try properties.decodeIfPresent(Weight.self, forKey: .weight)
                )
            } else {
                base = .system(
                    size: try properties.decode(Double.self, forKey: .size),
                    weight: try properties.decodeIfPresent(Weight.self, forKey: .weight),
                    design: try properties.decodeIfPresent(Design.self, forKey: .design)
                )
            }
        case .custom:
            let properties = try container.nestedContainer(keyedBy: CodingKeys.Custom.self, forKey: .properties)
            let name = try properties.decode(String.self, forKey: .name)
            if let fixedSize = try properties.decodeIfPresent(Double.self, forKey: .fixedSize) {
                base = .custom(
                    name,
                    fixedSize: fixedSize
                )
            } else {
                base = .custom(
                    name,
                    size: try properties.decode(Double.self, forKey: .size),
                    relativeTo: try properties.decodeIfPresent(TextStyle.self, forKey: .style) ?? .body
                )
            }
        }
        
        var modifiers = try container.nestedUnkeyedContainer(forKey: .modifiers)
        while let modifier = try? modifiers.nestedContainer(keyedBy: CodingKeys.Modifier.self) {
            switch try modifier.decode(FontModifier.self, forKey: .type) {
            case .bold:
                base = base.bold()
            case .italic:
                base = base.italic()
            case .monospaced:
                base = base.monospaced()
            case .monospacedDigit:
                base = base.monospacedDigit()
            case .smallCaps:
                base = base.smallCaps()
            case .lowercaseSmallCaps:
                base = base.lowercaseSmallCaps()
            case .uppercaseSmallCaps:
                base = base.uppercaseSmallCaps()
            case .weight:
                base = base.weight(try modifier.decode(Font.Weight.self, forKey: .properties))
            case .width:
                base = base.width(try modifier.decode(Font.Width.self, forKey: .properties))
            case .leading:
                base = base.leading(try modifier.decode(Font.Leading.self, forKey: .properties))
            }
        }
        
        self = base
    }
    
    enum FontType: String, Decodable {
        case system
        case custom
    }
    
    enum FontModifier: String, Decodable {
        case bold
        case italic
        case monospaced
        case monospacedDigit = "monospaced_digit"
        case smallCaps = "small_caps"
        case lowercaseSmallCaps = "lowercase_small_caps"
        case uppercaseSmallCaps = "uppercase_small_caps"
        case weight
        case width
        case leading
    }
    
    enum CodingKeys: String, CodingKey {
        case type
        case properties
        case modifiers
        
        enum Modifier: String, CodingKey {
            case type
            case properties
        }
        
        enum System: String, CodingKey {
            case style
            case size
            case design
            case weight
        }
        
        enum Custom: String, CodingKey {
            case name
            case size
            case fixedSize
            case style
        }
    }
}

/// A font's weight.
///
/// Possible values:
/// * `ultra_light`
/// * `thin`
/// * `light`
/// * `regular`
/// * `medium`
/// * `semibold`
/// * `bold`
/// * `heavy`
/// * `black`
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
extension Font.Weight: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        switch try container.decode(String.self) {
        case "ultra_light": self = .ultraLight
        case "thin": self = .thin
        case "light": self = .light
        case "regular": self = .regular
        case "medium": self = .medium
        case "semibold": self = .semibold
        case "bold": self = .bold
        case "heavy": self = .heavy
        case "black": self = .black
        case let `default`: throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Unknown weight named \(`default`)"))
        }
    }
}

/// The width to use for font's that support multiple widths.
///
/// Possible values:
/// * `standard`
/// * `tight`
/// * `loose`
/// * a custom number
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
extension Font.Width: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let name = try? container.decode(String.self) {
            switch name {
            case "compressed": self = .compressed
            case "condensed": self = .condensed
            case "standard": self = .standard
            case "expanded": self = .expanded
            default: throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Unknown width named \(name)"))
            }
        } else {
            self.init(try container.decode(Double.self))
        }
    }
}

/// A font's line spacing.
///
/// Possible values:
/// * `standard`
/// * `tight`
/// * `loose`
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
extension Font.Leading: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        switch try container.decode(String.self) {
        case "standard": self = .standard
        case "tight": self = .tight
        case "loose": self = .loose
        case let `default`: throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Unknown leading named \(`default`)"))
        }
    }
}

/// A system font design.
///
/// Possible values:
/// * `default`
/// * `serif`
/// * `rounded`
/// * `monospaced`
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
extension Font.Design: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        switch try container.decode(String.self) {
        case "default": self = .`default`
        case "serif": self = .serif
        case "rounded": self = .rounded
        case "monospaced": self = .monospaced
        case let `default`: throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Unknown design named \(`default`)"))
        }
    }
}

/// A system text style.
///
/// Possible values:
/// * `large_title`
/// * `title`
/// * `title2`
/// * `title3`
/// * `headline`
/// * `subheadline`
/// * `body`
/// * `callout`
/// * `footnote`
/// * `caption`
/// * `caption2`
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
extension Font.TextStyle: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        switch try container.decode(String.self) {
        case "large_title": self = .largeTitle
        case "title": self = .title
        case "title2": self = .title2
        case "title3": self = .title3
        case "headline": self = .headline
        case "subheadline": self = .subheadline
        case "body": self = .body
        case "callout": self = .callout
        case "footnote": self = .footnote
        case "caption": self = .caption
        case "caption2": self = .caption2
        case let `default`: throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Unknown style named \(`default`)"))
        }
    }
}
