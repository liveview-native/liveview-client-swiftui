//
//  NavigationBarItem+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 10/19/23.
//

import SwiftUI
import LiveViewNativeStylesheet

#if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
/// See [`SwiftUI.NavigationBarItem.TitleDisplayMode`](https://developer.apple.com/documentation/swiftui/NavigationBarItem/TitleDisplayMode) for more details.
///
/// Possible values:
/// - `.automatic`
/// - `.inline`
/// - `.large`
@_documentation(visibility: public)
extension NavigationBarItem.TitleDisplayMode: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
                ConstantAtomLiteral("automatic").map({ Self.automatic })
                ConstantAtomLiteral("inline").map({ Self.inline })
                #if os(watchOS)
                ConstantAtomLiteral("large").map({ Self.large })
                #endif
            }
        }
    }
}
#endif
