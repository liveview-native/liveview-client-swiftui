//
//  MaterialActiveAppearance+ParseableModifierValue.swift
//  
//
//  Created by Carson Katri on 6/18/24.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See []() for more details.
///
/// Possible values:
/// - `.inactive`
/// - `.active`
/// - `.automatic`
/// - `.matchWindow`
@_documentation(visibility: public)
@available(iOS 18, macOS 15.0, tvOS 18, visionOS 2, watchOS 11, *)
extension MaterialActiveAppearance: @retroactive ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
                #if os(macOS)
                ConstantAtomLiteral("inactive").map({ Self.inactive })
                #endif
                ConstantAtomLiteral("active").map({ Self.active })
                ConstantAtomLiteral("automatic").map({ Self.automatic })
                ConstantAtomLiteral("matchWindow").map({ Self.matchWindow })
            }
        }
    }
}
