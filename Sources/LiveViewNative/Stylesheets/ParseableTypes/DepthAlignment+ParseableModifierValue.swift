//
//  DepthAlignment+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 4/30/24.
//

#if os(visionOS)
import SwiftUI
import LiveViewNativeStylesheet

extension DepthAlignment: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember([
            "back": .back,
            "center": .center,
            "front": .front,
        ])
    }
}
#endif
