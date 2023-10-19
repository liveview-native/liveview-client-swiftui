//
//  Event+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 10/19/23.
//

import SwiftUI
import LiveViewNativeStylesheet
import LiveViewNativeCore

extension Event: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ASTNode("__event__") {
            String.parser(in: context)
        }
        .map { (meta, value) in
            return Self.init(AttributeName(rawValue: value)!, type: "click")
        }
    }
    
//    {:__event__, [], ["<event name>", [throttle:debounce:]]}
}
