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
        AttributeName.parser(in: context).map({ Self.init(attribute: $0) })
    }
}
