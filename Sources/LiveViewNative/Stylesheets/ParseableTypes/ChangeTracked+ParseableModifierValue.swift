//
//  ChangeTracked+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 10/18/23.
//

import SwiftUI
import LiveViewNativeStylesheet
import LiveViewNativeCore

extension ChangeTracked: ParseableModifierValue where Value: AttributeDecodable {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ASTNode("__attr__") {
            String.parser(in: context)
        }
        .map { (meta, value) in
            return Self.init(attribute: AttributeName(rawValue: value)!)
        }
    }
    
    // {:__attr__, [], \"test-value\"}
}
