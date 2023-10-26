//
//  TextCase+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 10/26/23.
//

import SwiftUI
import LiveViewNativeStylesheet

extension SwiftUI.Text.Case: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember([
            "uppercase": .uppercase,
            "lowercase": .lowercase
        ])
    }
}
