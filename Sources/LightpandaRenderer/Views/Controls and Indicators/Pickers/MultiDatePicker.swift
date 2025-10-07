//
//  MultiDatePicker.swift
//  LightpandaRenderer
//
//  Created by Shadowfacts on 3/8/23.
//

import SwiftUI
import LightpandaClient

/// A control that allows the user to pick multiple dates (not datetimes).
///
/// ```html
/// <MultiDatePicker selection={@dates} phx-change="dates-changed" start="2023-01-01" end="2023-02-01">
///     <Text>Pick as many dates as you like!</Text>
/// </MultiDatePicker>
/// ```
///
/// The element's children are used as the control's label.
///
/// The value is a list of date strings of the form "yyyy-MM-dd".
///
/// - Note: This control does not support reading the intial value from the `selection` attribute on the element.
///
/// ## Attributes
/// - ``selection``
/// - ``start``
/// - ``end``
@_documentation(visibility: public)
@available(iOS 16.0, *)
struct MultiDatePicker<Library: ElementLibrary>: View {
    let node: Node
    
    /// The start date (inclusive) of the picker's range.
    @_documentation(visibility: public)
    private var start: Date? {
        node.attributeValue(for: "start", strategy: .dateTime)
    }
    
    /// The end date (**exclusive**) of the picker's range.
    @_documentation(visibility: public)
    private var end: Date? {
        node.attributeValue(for: "end", strategy: .dateTime)
    }
    
    @FormState(.init(name: "selection"), default: []) private var selection: Set<SelectedDate>
    
    private var dateComponents: Binding<Set<DateComponents>> {
        Binding {
            Set(self.selection.map(\.dateComponents))
        } set: {
            self.selection = Set($0.map(SelectedDate.init(dateComponents:)))
        }
    }
    
    var body: some View {
        #if os(iOS)
        if let start, let end {
            SwiftUI.MultiDatePicker(selection: dateComponents, in: start..<end) {
                node.children(library: Library.self)
            }
        } else if let start {
            SwiftUI.MultiDatePicker(selection: dateComponents, in: start...) {
                node.children(library: Library.self)
            }
        } else if let end {
            SwiftUI.MultiDatePicker(selection: dateComponents, in: ..<end) {
                node.children(library: Library.self)
            }
        } else {
            SwiftUI.MultiDatePicker(selection: dateComponents) {
                node.children(library: Library.self)
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
