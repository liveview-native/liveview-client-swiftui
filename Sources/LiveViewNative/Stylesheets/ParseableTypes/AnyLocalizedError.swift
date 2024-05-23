//
//  AnyLocalizedError.swift
//
//
//  Created by Carson Katri on 11/9/23.
//

import SwiftUI
import LiveViewNativeStylesheet

/// A string that represents an error message.
@_documentation(visibility: public)
struct AnyLocalizedError: LocalizedError, ParseableModifierValue {
    var errorDescription: String?
    
    static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        String.parser(in: context).map(Self.init(errorDescription:))
    }
}
