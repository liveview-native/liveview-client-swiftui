//
//  Alignment+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 10/17/23.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.Alignment`](https://developer.apple.com/documentation/swiftui/Animation) for more details.
///
/// Possible values:
/// - `centerFirstTextBaseline`
/// - `centerLastTextBaseline`
/// - `leadingFirstTextBaseline`
/// - `leadingLastTextBaseline`
/// - `trailingFirstTextBaseline`
/// - `trailingLastTextBaseline`
/// - `topLeading`
/// - `topTrailing`
/// - `bottomLeading`
/// - `bottomTrailing`
/// - `top`
/// - `bottom`
/// - `center`
/// - `leading`
/// - `trailing`
@_documentation(visibility: public)
extension Alignment: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
                ConstantAtomLiteral("centerFirstTextBaseline").map({ Self.centerFirstTextBaseline })
                ConstantAtomLiteral("centerLastTextBaseline").map({ Self.centerLastTextBaseline })
                
                ConstantAtomLiteral("leadingFirstTextBaseline").map({ Self.leadingFirstTextBaseline })
                ConstantAtomLiteral("leadingLastTextBaseline").map({ Self.leadingLastTextBaseline })
                
                ConstantAtomLiteral("trailingFirstTextBaseline").map({ Self.trailingFirstTextBaseline })
                ConstantAtomLiteral("trailingLastTextBaseline").map({ Self.trailingLastTextBaseline })
                
                ConstantAtomLiteral("topLeading").map({ Self.topLeading })
                ConstantAtomLiteral("topTrailing").map({ Self.topTrailing })
                
                ConstantAtomLiteral("bottomLeading").map({ Self.bottomLeading })
                ConstantAtomLiteral("bottomTrailing").map({ Self.bottomTrailing })
                
                ConstantAtomLiteral("top").map({ Self.top })
                ConstantAtomLiteral("bottom").map({ Self.bottom })
                ConstantAtomLiteral("center").map({ Self.center })
                ConstantAtomLiteral("leading").map({ Self.leading })
                ConstantAtomLiteral("trailing").map({ Self.trailing })
            }
        }
    }
}
