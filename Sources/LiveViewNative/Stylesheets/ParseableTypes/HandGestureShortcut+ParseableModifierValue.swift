//
//  HandGestureShortcut+ParseableModifierValue.swift
//  
//
//  Created by Carson Katri on 6/18/24.
//

import SwiftUI
import LiveViewNativeStylesheet

#if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
@available(iOS 18, macOS 15, tvOS 18, watchOS 11, *)
extension HandGestureShortcut: @retroactive ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember([
            "primaryAction": .primaryAction
        ])
    }
}
#endif
