//
//  Text+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 11/21/23.
//

import SwiftUI
import LiveViewNativeStylesheet

extension SwiftUI.Text.TruncationMode: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember([
            "head": .head,
            "tail": .tail,
            "middle": .middle,
        ])
    }
}

extension TextAlignment: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember([
            "leading": .leading,
            "center": .center,
            "trailing": .trailing,
        ])
    }
}

extension SwiftUI.Text.Case: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember([
            "uppercase": .uppercase,
            "lowercase": .lowercase
        ])
    }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.Text.Scale: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember([
            "default": .default,
            "secondary": .secondary
        ])
    }
}

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
