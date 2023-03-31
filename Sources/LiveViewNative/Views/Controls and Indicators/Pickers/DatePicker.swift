//
//  DatePicker.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 2/17/23.
//

import SwiftUI
import LiveViewNativeCore

/// A control that lets the user pick a date.
///
/// The value of this control is an Elixir-style ISO 8601 date or datetime string (i.e., the result of `DateTime.to_iso8601`).
///
/// ```html
/// <DatePicker value="2023-03-14T15:19:26.535Z">
///     <Text>Pick a date</Text>
/// </DatePicker>
/// ```
///
/// Children of the `DatePicker` element are used as the label for the control.
///
/// ### Specifying a Date Range
/// You can optionally specify a start and/or end date to limit the selectable range of the date picker.
///
/// ## Attributes
/// - ``start``
/// - ``end``
/// - ``components``
/// - ``style``
///
/// ## Topics
/// ### Supporting Types
/// - ``DatePickerStyle``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(iOS 16.0, macOS 13.0, *)
struct DatePicker<R: RootRegistry>: View {
    @LiveContext<R> private var context
    @ObservedElement private var element
    @FormState(default: CodableDate()) private var value: CodableDate
    ///The start date (inclusive) of the valid date range. Encoded as an ISO 8601 date or datetime string.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("start") private var start: Date?
    ///The end date (inclusive) of the valid date range. Encoded as an ISO 8601 date or datetime string.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("end") private var end: Date?
    ///Which components of the date to display in the picker. Defaults to all.
    ///
    ///Possible values:
    ///- `hour-and-minute`
    ///- `date`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute(
        "displayed-components",
        transform: {
            #if os(iOS) || os(macOS)
            switch $0?.value {
            case "hour-and-minute":
                return .hourAndMinute
            case "date":
                return .date
            default:
                return [.hourAndMinute, .date]
            }
            #else
            fatalError()
            #endif
        }
    ) private var components: DatePickerComponents
    #if !os(iOS) && !os(macOS)
    typealias DatePickerComponents = Never
    #endif
    ///The style of the date picker.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("date-picker-style") private var style: DatePickerStyle = .automatic
    
    private var dateBinding: Binding<Date> {
        Binding {
            value.date
        } set: { newValue in
            value.date = newValue
        }
    }
    
    var body: some View {
#if os(iOS) || os(macOS)
        if let start, let end {
            SwiftUI.DatePicker(selection: dateBinding, in: start...end, displayedComponents: components) {
                context.buildChildren(of: element)
            }
            .applyDatePickerStyle(style)
        } else if let start {
            SwiftUI.DatePicker(selection: dateBinding, in: start..., displayedComponents: components) {
                context.buildChildren(of: element)
            }
            .applyDatePickerStyle(style)
        } else if let end {
            SwiftUI.DatePicker(selection: dateBinding, in: ...end, displayedComponents: components) {
                context.buildChildren(of: element)
            }
            .applyDatePickerStyle(style)
        } else {
            SwiftUI.DatePicker(selection: dateBinding, displayedComponents: components) {
                context.buildChildren(of: element)
            }
            .applyDatePickerStyle(style)
        }
#endif
    }
}

/// A `Date` wrapper that encodes/decodes using the Elixir date formats.
private struct CodableDate: FormValue {
    var date: Date
    
    init() {
        self.date = Date()
    }
    
    init(from attribute: LiveViewNativeCore.Attribute?) throws {
        guard let value = attribute?.value else {
            throw AttributeDecodingError.missingAttribute(CodableDate.self)
        }
        self.date = try Date(value, strategy: .elixirDateTimeOrDate)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let s = try container.decode(String.self)
        self.date = try Date(s, strategy: .elixirDateTimeOrDate)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(date.formatted(.elixirDateTime))
    }
}

/// The style of a ``DatePicker``.
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
private enum DatePickerStyle: String, AttributeDecodable {
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @available(iOS 16.0, tvOS 16.0, watchOS 9.0, macOS 13.0, *)
    case automatic
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @available(iOS 16.0, tvOS 16.0, watchOS 9.0, macOS 13.0, *)
    case compact
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @available(iOS 16.0, tvOS 16.0, watchOS 9.0, macOS 13.0, *)
    case graphical
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @available(iOS 16.0, *)
    case wheel
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @available(macOS 13.0, *)
    case field
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @available(macOS 13.0, *)
    case stepperField = "stepper-field"
}

#if os(iOS) || os(macOS)
private extension View {
    @ViewBuilder
    func applyDatePickerStyle(_ style: DatePickerStyle?) -> some View {
        switch style {
        case .automatic, nil:
            self.datePickerStyle(.automatic)
        case .compact:
            self.datePickerStyle(.compact)
        case .graphical:
            self.datePickerStyle(.graphical)
        case .wheel:
#if os(iOS)
            self.datePickerStyle(.wheel)
#endif
        case .field:
#if os(macOS)
            self.datePickerStyle(.field)
#endif
        case .stepperField:
#if os(macOS)
            self.datePickerStyle(.stepperField)
#endif
        }
    }
}
#endif
