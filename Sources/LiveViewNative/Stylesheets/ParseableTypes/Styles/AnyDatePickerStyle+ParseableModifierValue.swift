//
//  AnyDatePickerStyle+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 11/14/23.
//

import SwiftUI
import LiveViewNativeStylesheet

#if os(iOS) || os(macOS) || os(watchOS) || os(xrOS)
enum AnyDatePickerStyle: String, CaseIterable, ParseableModifierValue, DatePickerStyle {
    typealias _ParserType = ImplicitStaticMember<Self, EnumParser<Self>>
    
    case automatic
    #if os(iOS) || os(macOS) || os(xrOS)
    case compact
    case graphical
    #endif
    #if os(macOS)
    case field
    case stepperField
    #endif
    #if os(iOS) || os(watchOS) || os(xrOS)
    case wheel
    #endif
    
    func makeBody(configuration: Configuration) -> some View {
        switch self {
        case .automatic:
            if #available(watchOS 10, *) {
                DefaultDatePickerStyle().makeBody(configuration: configuration)
            }
        #if os(iOS) || os(macOS) || os(xrOS)
        case .compact:
            CompactDatePickerStyle().makeBody(configuration: configuration)
        case .graphical:
            GraphicalDatePickerStyle().makeBody(configuration: configuration)
        #endif
        #if os(macOS)
        case .field:
            FieldDatePickerStyle().makeBody(configuration: configuration)
        case .stepperField:
            StepperFieldDatePickerStyle().makeBody(configuration: configuration)
        #endif
        #if os(iOS) || os(watchOS) || os(xrOS)
        case .wheel:
            if #available(watchOS 10, *) {
                WheelDatePickerStyle().makeBody(configuration: configuration)
            }
        #endif
        }
    }
}
#endif
