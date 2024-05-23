//
//  Text+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 11/21/23.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.Text.TruncationMode`](https://developer.apple.com/documentation/swiftui/Text/TruncationMode) for more details.
///
/// Possible values:
/// - `.head`
/// - `.tail`
/// - `.middle`
@_documentation(visibility: public)
extension SwiftUI.Text.TruncationMode: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember([
            "head": .head,
            "tail": .tail,
            "middle": .middle,
        ])
    }
}

/// See [`SwiftUI.TextAlignment`](https://developer.apple.com/documentation/swiftui/TextAlignment) for more details.
///
/// Possible values:
/// - `.leading`
/// - `.center`
/// - `.trailing`
@_documentation(visibility: public)
extension TextAlignment: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember([
            "leading": .leading,
            "center": .center,
            "trailing": .trailing,
        ])
    }
}

/// See [`SwiftUI.Text.Case`](https://developer.apple.com/documentation/swiftui/Text/Case) for more details.
///
/// Possible values:
/// - `.uppercase`
/// - `.lowercase`
@_documentation(visibility: public)
extension SwiftUI.Text.Case: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember([
            "uppercase": .uppercase,
            "lowercase": .lowercase
        ])
    }
}

/// See [`SwiftUI.Text.Scale`](https://developer.apple.com/documentation/swiftui/Text/Scale) for more details.
///
/// Possible values:
/// - `.default`
/// - `.secondary`
@_documentation(visibility: public)
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.Text.Scale: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember([
            "default": .default,
            "secondary": .secondary
        ])
    }
}

/// See [`SwiftUI.Text.LineStyle`](https://developer.apple.com/documentation/swiftui/Text/LineStyle) for more details.
///
/// Standard Line Styles:
/// - `.single`
///
/// Create a custom `LineStyle` with a ``SwiftUI/Text/LineStyle/Pattern`` and ``SwiftUI/Color``.
///
/// ```swift
/// LineStyle(pattern: .dashDotDot, color: .red)
/// LineStyle(pattern: .dash)
/// LineStyle(pattern: .solid, color: .blue)
/// ```
@_documentation(visibility: public)
extension SwiftUI.Text.LineStyle: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            ImplicitStaticMember(["single": .single])
            _TextLineStyle.parser(in: context).map(\.value)
        }
    }
}

@ParseableExpression
struct _TextLineStyle {
    static let name = "LineStyle"
    let value: SwiftUI.Text.LineStyle
    
    init(pattern: SwiftUI.Text.LineStyle.Pattern = .solid, color: Color? = nil) {
        self.value = .init(pattern: pattern, color: color)
    }
}

/// See [`SwiftUI.Text.LineStyle.Pattern`](https://developer.apple.com/documentation/swiftui/Text/LineStyle/Pattern) for more details.
///
/// Possible values:
/// - `.solid`
/// - `.dot`
/// - `.dash`
/// - `.dashDot`
/// - `.dashDotDot`
@_documentation(visibility: public)
extension SwiftUI.Text.LineStyle.Pattern: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember([
            "solid": .solid,
            "dot": .dot,
            "dash": .dash,
            "dashDot": .dashDot,
            "dashDotDot": .dashDotDot,
        ])
    }
}
