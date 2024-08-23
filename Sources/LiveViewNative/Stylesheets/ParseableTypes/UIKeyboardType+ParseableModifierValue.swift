//
//  UIKeyboardType+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 10/26/23.
//

import SwiftUI
import LiveViewNativeStylesheet

#if os(iOS) || os(tvOS) || os(visionOS)
/// See [`UIKit.UIKeyboardType`](https://developer.apple.com/documentation/uikit/UIKeyboardType) for more details.
///
/// Possible values:
/// - `.default`
/// - `.asciiCapable`
/// - `.numbersAndPunctuation`
/// - `.URL`
/// - `.numberPad`
/// - `.phonePad`
/// - `.namePhonePad`
/// - `.emailAddress`
/// - `.decimalPad`
/// - `.twitter`
/// - `.webSearch`
/// - `.asciiCapableNumberPad`
@_documentation(visibility: public)
extension UIKeyboardType: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember([
            "default": .default,
            "asciiCapable": .asciiCapable,
            "numbersAndPunctuation": .numbersAndPunctuation,
            "URL": .URL,
            "numberPad": .numberPad,
            "phonePad": .phonePad,
            "namePhonePad": .namePhonePad,
            "emailAddress": .emailAddress,
            "decimalPad": .decimalPad,
            "twitter": .twitter,
            "webSearch": .webSearch,
            "asciiCapableNumberPad": .asciiCapableNumberPad,
        ])
    }
}
#endif
