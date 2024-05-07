//
//  ImageScale+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 10/26/23.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.Image.Scale`](https://developer.apple.com/documentation/swiftui/Image/Scale) for more details.
///
/// Possible values:
/// - `.small`
/// - `.medium`
/// - `.large`
@_documentation(visibility: public)
extension SwiftUI.Image.Scale: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember([
            "small": .small,
            "medium": .medium,
            "large": .large,
        ])
    }
}
