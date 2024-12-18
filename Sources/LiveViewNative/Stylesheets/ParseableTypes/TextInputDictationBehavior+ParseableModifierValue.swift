//
//  TextInputDictationBehavior+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 11/21/23.
//

import SwiftUI
import LiveViewNativeStylesheet

#if os(iOS) || os(visionOS)
/// See [`SwiftUI.TextInputDictationBehavior`](https://developer.apple.com/documentation/swiftui/TextInputDictationBehavior) for more details.
///
/// Possible values:
/// - `.automatic`
/// - `.preventDictation`
///
/// Use ``SwiftUI/TextInputDictationActivation`` to create an `inline` activation.
///
/// ```swift
/// .inline(activation: .onLook)
/// .inline(activation: .onSelect)
/// ```
@_documentation(visibility: public)
@available(iOS 17, *)
extension TextInputDictationBehavior: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
                ConstantAtomLiteral("automatic").map({ Self.automatic })
                Inline.parser(in: context).map({ Self.inline(activation: $0.activation) })
                #if os(visionOS)
                if #available(visionOS 1.0, *) {
                    ConstantAtomLiteral("preventDictation").map({ Self.preventDictation })
                }
                #endif
            }
        }
    }
    
    @ASTDecodable("inline")
    struct Inline {
        let activation: TextInputDictationActivation
        
        init(activation: TextInputDictationActivation) {
            self.activation = activation
        }
    }
}

/// See [`SwiftUI.TextInputDictationActivation`](https://developer.apple.com/documentation/swiftui/TextInputDictationActivation) for more details.
///
/// Possible values:
/// - `.onLook`
/// - `.onSelect`
@_documentation(visibility: public)
@available(iOS 17, *)
extension TextInputDictationActivation: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember([
            "onLook": .onLook,
            "onSelect": .onSelect
        ])
    }
}
#endif
