//
//  Alignment+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 10/17/23.
//

import SwiftUI
import LiveViewNativeStylesheet

extension Alignment: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
                ConstantAtomLiteral("top").map({ Self.top })
                ConstantAtomLiteral("topLeading").map({ Self.topLeading })
                ConstantAtomLiteral("topTrailing").map({ Self.topTrailing })
                
                ConstantAtomLiteral("center").map({ Self.center })
                ConstantAtomLiteral("leading").map({ Self.leading })
                ConstantAtomLiteral("trailing").map({ Self.trailing })
                
                ConstantAtomLiteral("bottom").map({ Self.bottom })
                ConstantAtomLiteral("bottomLeading").map({ Self.bottomLeading })
                ConstantAtomLiteral("bottomTrailing").map({ Self.bottomTrailing })
                
                ConstantAtomLiteral("centerFirstTextBaseline").map({ Self.centerFirstTextBaseline })
                ConstantAtomLiteral("centerLastTextBaseline").map({ Self.centerLastTextBaseline })
                ConstantAtomLiteral("leadingFirstTextBaseline").map({ Self.leadingFirstTextBaseline })
                ConstantAtomLiteral("leadingLastTextBaseline").map({ Self.leadingLastTextBaseline })
                ConstantAtomLiteral("trailingFirstTextBaseline").map({ Self.trailingFirstTextBaseline })
                ConstantAtomLiteral("trailingLastTextBaseline").map({ Self.trailingLastTextBaseline })
            }
        }
    }
}
