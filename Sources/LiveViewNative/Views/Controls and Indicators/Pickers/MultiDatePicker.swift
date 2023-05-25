//
//  MultiDatePicker.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 3/8/23.
//

import SwiftUI

/// A control that allows the user to pick multiple dates (not datetimes).
///
/// ```html
/// <MultiDatePicker value-binding="dates" start="2023-01-01" end="2023-02-01">
///     <Text>Pick as many dates as you like!</Text>
/// </MultiDatePicker>
/// ```
///
/// The element's children are used as the control's label.
///
/// ```elixir
/// defmodule MyAppWeb.DatesLive do
///     native_binding :dates, List, ["2023-01-15"]
/// end
/// ```
///
/// The value is a list of date strings of the form "yyyy-MM-dd".
///
/// - Note: This control does not support reading the intial value from the `value` attribute on the element.
///
/// ## Attributes
/// - ``start``
/// - ``end``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(iOS 16.0, *)
struct MultiDatePicker<R: RootRegistry>: View {
    @LiveContext<R> private var context
    @ObservedElement private var element
    /// The start date (inclusive) of the picker's range.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("start") private var start: Date?
    /// The end date (**exclusive**) of the picker's range.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("end") private var end: Date?
    @FormState(default: []) private var dates: Set<SelectedDate>
    
    private var dateComponents: Binding<Set<DateComponents>> {
        Binding {
            Set(self.dates.map(\.dateComponents))
        } set: {
            self.dates = Set($0.map(SelectedDate.init(dateComponents:)))
        }
    }
    
    var body: some View {
        #if os(iOS)
        if let start, let end {
            SwiftUI.MultiDatePicker(selection: dateComponents, in: start..<end) {
                context.buildChildren(of: element)
            }
        } else if let start {
            SwiftUI.MultiDatePicker(selection: dateComponents, in: start...) {
                context.buildChildren(of: element)
            }
        } else if let end {
            SwiftUI.MultiDatePicker(selection: dateComponents, in: ..<end) {
                context.buildChildren(of: element)
            }
        } else {
            SwiftUI.MultiDatePicker(selection: dateComponents) {
                context.buildChildren(of: element)
            }
        }
        #endif
    }
    
    struct SelectedDate: Codable, Equatable, Hashable, FormValue {
        let dateComponents: DateComponents
        
        init(dateComponents: DateComponents) {
            self.dateComponents = dateComponents
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let string = try container.decode(String.self)
            let date = try Date(string, strategy: .elixirDate)
            self.dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            let date = dateComponents.date!
            try container.encode(date.formatted(.elixirDate))
        }
    }
}
