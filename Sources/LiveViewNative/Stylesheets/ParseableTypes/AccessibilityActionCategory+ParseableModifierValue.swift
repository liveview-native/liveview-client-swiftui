//
//  AccessibilityActionCategory+ParseableModifierValue.swift
//  LiveViewNative
//
//  Created by Carson Katri on 10/3/24.
//

import SwiftUI
import LiveViewNativeStylesheet

@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
extension AccessibilityActionCategory: ParseableModifierValue {
    static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            ImplicitStaticMember([
                "default": Self.default,
                "edit": Self.edit
            ])
            ParseableAccessibilityActionCategory.parser(in: context).map(\.value)
        }
    }
    
    @ParseableExpression
    struct ParseableAccessibilityActionCategory {
        let value: AccessibilityActionCategory
        
        init(_ name: String) {
            self.value = .init(name)
        }
    }
}
