//
//  SurroundingsEffect+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 4/30/24.
//

#if os(visionOS)
import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.SurroundingsEffect`](https://developer.apple.com/documentation/swiftui/SurroundingsEffect) for more details.
///
/// Possible values:
/// - `.systemDark`
@_documentation(visibility: public)
extension SurroundingsEffect: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember([
            "systemDark": .systemDark
        ])
    }
}
#endif
