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
        ParseableEvent.parser(in: context)
        .map { value in
            return Self.init(
                event: value.event,
                type: value.type,
                debounce: value.debounce,
                throttle: value.throttle
            )
        }
    }
    
    @ParseableExpression
    struct ParseableEvent {
        static let name = "__event__"
        
        let event: String
        let type: String
        let debounce: Double?
        let throttle: Double?
        
        init(_ event: String, type: String = "click", debounce: Double?, throttle: Double?) {
            self.event = event
            self.type = type
            self.debounce = debounce
            self.throttle = throttle
        }
    }
}
