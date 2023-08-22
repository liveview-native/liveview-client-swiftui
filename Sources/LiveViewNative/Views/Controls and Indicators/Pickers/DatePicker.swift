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
/// - ``selection``
/// - ``start``
/// - ``end``
/// - ``components``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(iOS 16.0, macOS 13.0, *)
struct DatePicker<R: RootRegistry>: View {
    @LiveContext<R> private var context
    @ObservedElement private var element
    @FormState("selection", default: CodableDate()) private var selection: CodableDate
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
    
    var body: some View {
#if os(iOS) || os(macOS)
        if let start, let end {
            SwiftUI.DatePicker(selection: $selection.date, in: start...end, displayedComponents: components) {
                context.buildChildren(of: element)
            }
        } else if let start {
            SwiftUI.DatePicker(selection: $selection.date, in: start..., displayedComponents: components) {
                context.buildChildren(of: element)
            }
        } else if let end {
            SwiftUI.DatePicker(selection: $selection.date, in: ...end, displayedComponents: components) {
                context.buildChildren(of: element)
            }
        } else {
            SwiftUI.DatePicker(selection: $selection.date, displayedComponents: components) {
                context.buildChildren(of: element)
            }
        }
#endif
    }
}

/// A `Date` wrapper that encodes/decodes using the Elixir date formats.
private struct CodableDate: FormValue, AttributeDecodable {
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

