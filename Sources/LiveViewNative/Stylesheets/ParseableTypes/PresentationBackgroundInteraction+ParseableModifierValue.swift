//
//  PresentationBackgroundInteraction+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 11/22/23.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.PresentationBackgroundInteraction`](https://developer.apple.com/documentation/swiftui/PresentationBackgroundInteraction) for more details.
///
/// Possible values:
/// - `.automatic`
/// - `.enabled`
/// - `.enabled(upThrough: PresentationDetent)`, with a ``SwiftUI/PresentationDetent``
/// - `.disabled`
@_documentation(visibility: public)
@available(iOS 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
extension PresentationBackgroundInteraction: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
                ConstantAtomLiteral("automatic").map({ Self.automatic })
                ConstantAtomLiteral("enabled").map({ Self.enabled })
                Enabled.parser(in: context).map({ Self.enabled(upThrough: $0.detent) })
                ConstantAtomLiteral("disabled").map({ Self.disabled })
            }
        }
    }
    
    @ASTDecodable("enabled")
    struct Enabled {
        let detent: PresentationDetent
        
        init(upThrough detent: PresentationDetent) {
            self.detent = detent
        }
    }
}
