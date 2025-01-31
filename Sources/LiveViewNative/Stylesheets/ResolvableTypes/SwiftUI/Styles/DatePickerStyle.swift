//
//  DatePickerStyle.swift
//  LiveViewNative
//
//  Created by Carson Katri on 1/30/25.
//

import SwiftUI
import LiveViewNativeStylesheet
import LiveViewNativeCore

@ASTDecodable("DatePickerStyle")
enum StylesheetResolvableDatePickerStyle: DatePickerStyle, StylesheetResolvable {
    case automatic
    case compact
    #if os(macOS)
    case field
    #endif
    case graphical
    #if os(macOS)
    case stepperField
    #endif
    #if os(iOS) || os(watchOS) || os(visionOS)
    case wheel
    #endif
}

extension StylesheetResolvableDatePickerStyle {
    @MainActor func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Self {
        return self
    }
    
    @ViewBuilder
    func makeBody(configuration: Configuration) -> some View {
        switch self {
        case .automatic:
            DefaultDatePickerStyle().makeBody(configuration: configuration)
        case .compact:
            CompactDatePickerStyle().makeBody(configuration: configuration)
        #if os(macOS)
        case .field:
            FieldDatePickerStyle().makeBody(configuration: configuration)
        #endif
        case .graphical:
            GraphicalDatePickerStyle().makeBody(configuration: configuration)
        #if os(macOS)
        case .stepperField:
            StepperFieldDatePickerStyle().makeBody(configuration: configuration)
        #endif
        #if os(iOS) || os(watchOS) || os(visionOS)
        case .wheel:
            WheelDatePickerStyle().makeBody(configuration: configuration)
        #endif
        }
    }
}

extension StylesheetResolvableDatePickerStyle: AttributeDecodable {
    nonisolated init(from attribute: Attribute?, on element: ElementNode) throws {
        switch attribute?.value {
        case "automatic":
            self = .automatic
        case "compact":
            self = .compact
        #if os(macOS)
        case "field":
            self = .field
        #endif
        case "graphical":
            self = .graphical
        #if os(macOS)
        case "stepperField":
            self = .stepperField
        #endif
        #if os(iOS) || os(watchOS) || os(visionOS)
        case "wheel":
            self = .wheel
        #endif
        default:
            throw AttributeDecodingError.badValue(Self.self)
        }
    }
}
