//
//  AnyTextSelectability.swift
//
//
//  Created by Carson Katri on 11/21/23.
//

import SwiftUI
import LiveViewNativeStylesheet

enum AnyTextSelectability: String, CaseIterable, ParseableModifierValue {
    typealias _ParserType = ImplicitStaticMember<Self, EnumParser<Self>>
    
    case enabled
    case disabled
}

extension View {
#if os(iOS) || os(macOS) || os(xrOS)
    @_disfavoredOverload
    @ViewBuilder
    func textSelection(_ selectability: AnyTextSelectability) -> some View {
        switch selectability {
        case .enabled:
            self.textSelection(EnabledTextSelectability.enabled)
        case .disabled:
            self.textSelection(DisabledTextSelectability.disabled)
        }
    }
#endif
}
