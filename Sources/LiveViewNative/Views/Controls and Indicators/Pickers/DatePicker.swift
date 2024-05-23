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
/// <DatePicker selection="2023-03-14T15:19:26.535Z">
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
@_documentation(visibility: public)
@available(iOS 16.0, macOS 13.0, *)
@LiveElement
struct DatePicker<Root: RootRegistry>: View {
    @FormState("selection", default: CodableDate()) private var selection: CodableDate
    
    ///The start date (inclusive) of the valid date range. Encoded as an ISO 8601 date or datetime string.
    @_documentation(visibility: public)
    private var start: Date?
    
    ///The end date (inclusive) of the valid date range. Encoded as an ISO 8601 date or datetime string.
    @_documentation(visibility: public)
    private var end: Date?
    
    ///Which components of the date to display in the picker. Defaults to all.
    ///
    ///Possible values:
    ///- `hourAndMinute`
    ///- `date`
    @_documentation(visibility: public)
    private var displayedComponents: String?
    
    #if os(iOS) || os(macOS)
    private var datePickerComponents: DatePickerComponents {
        displayedComponents.flatMap({ DatePickerComponents.init(from: $0) }) ?? [.hourAndMinute, .date]
    }
    #endif
    
    var body: some View {
#if os(iOS) || os(macOS)
        if let start, let end {
            SwiftUI.DatePicker(selection: $selection.date, in: start...end, displayedComponents: datePickerComponents) {
                $liveElement.children()
            }
        } else if let start {
            SwiftUI.DatePicker(selection: $selection.date, in: start..., displayedComponents: datePickerComponents) {
                $liveElement.children()
            }
        } else if let end {
            SwiftUI.DatePicker(selection: $selection.date, in: ...end, displayedComponents: datePickerComponents) {
                $liveElement.children()
            }
        } else {
            SwiftUI.DatePicker(selection: $selection.date, displayedComponents: datePickerComponents) {
                $liveElement.children()
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
    
    init(from attribute: LiveViewNativeCore.Attribute?, on element: ElementNode) throws {
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
    
    func formQueryEncoded() throws -> String {
        ElixirDateTimeFormat().format(self.date)
    }
}

#if !os(iOS) && !os(macOS)
typealias DatePickerComponents = Never
#else
extension DatePickerComponents {
    public init(from string: String) {
        #if os(iOS) || os(macOS)
        switch string {
        case "hourAndMinute":
            self = .hourAndMinute
        case "date":
            self = .date
        default:
            self = [.hourAndMinute, .date]
        }
        #else
        fatalError()
        #endif
    }
}
#endif
