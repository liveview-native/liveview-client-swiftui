//
//  ContentMode+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 11/2/23.
//
import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.ContentMode`](https://developer.apple.com/documentation/swiftui/ContentMode) for more details.
///
/// Possible values:
/// - `.fill`
/// - `.fit`
@_documentation(visibility: public)
extension ContentMode: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember([
            "fill": .fill,
            "fit": .fit,
        ])
    }
}
