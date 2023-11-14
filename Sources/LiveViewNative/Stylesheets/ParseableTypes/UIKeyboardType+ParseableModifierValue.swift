//
//  UIKeyboardType+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 10/26/23.
//

import SwiftUI
import LiveViewNativeStylesheet

#if os(iOS) || os(tvOS) || os(xrOS)
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
