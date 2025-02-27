//
//  DatePickerStyle.swift
//  LiveViewNative
//
//  Created by Carson Katri on 1/30/25.
//

#if os(iOS) || os(macOS) || os(watchOS) || os(visionOS)
import SwiftUI
import LiveViewNativeStylesheet
import LiveViewNativeCore

@ASTDecodable("DatePickerStyle")
@available(iOS 13.0, macOS 10.15, watchOS 10.0, *)
enum StylesheetResolvableDatePickerStyle: @preconcurrency DatePickerStyle, StylesheetResolvable, @preconcurrency Decodable {
    case automatic
    #if os(iOS) || os(macOS) || os(visionOS)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    case compact
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    case graphical
    #endif
    #if os(macOS)
    @available(iOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @available(visionOS, unavailable)
    case field
    #endif
    #if os(macOS)
    @available(iOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @available(visionOS, unavailable)
    case stepperField
    #endif
    #if os(iOS) || os(watchOS) || os(visionOS)
    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    case wheel
    #endif
}

@available(iOS 13.0, macOS 10.15, watchOS 10.0, *)
extension StylesheetResolvableDatePickerStyle {
    @MainActor func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Self {
        return self
    }
    
    @ViewBuilder
    func makeBody(configuration: Configuration) -> some View {
        switch self {
        case .automatic:
            DefaultDatePickerStyle().makeBody(configuration: configuration)
        #if os(iOS) || os(macOS) || os(visionOS)
        case .compact:
            CompactDatePickerStyle().makeBody(configuration: configuration)
        case .graphical:
            GraphicalDatePickerStyle().makeBody(configuration: configuration)
        #endif
        #if os(macOS)
        case .field:
            FieldDatePickerStyle().makeBody(configuration: configuration)
        #endif
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

@available(iOS 13.0, macOS 10.15, watchOS 10.0, *)
extension StylesheetResolvableDatePickerStyle: @preconcurrency AttributeDecodable {
    nonisolated init(from attribute: Attribute?, on element: ElementNode) throws {
        switch attribute?.value {
        case "automatic":
            self = .automatic
        #if os(iOS) || os(macOS) || os(visionOS)
        case "compact":
            self = .compact
        case "graphical":
            self = .graphical
        #endif
        #if os(macOS)
        case "field":
            self = .field
        #endif
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
#endif
