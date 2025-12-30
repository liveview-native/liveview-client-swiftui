//
//  DatePicker.swift
//  LightpandaRenderer
//
//  Created by Shadowfacts on 2/17/23.
//

import SwiftUI
import LightpandaClient

/// A control that lets the user pick a date.
///
/// The value of this control is an ISO 8601 date string.
///
/// ```html
/// <DatePicker selection="2023-03-14T15:19:26Z">
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
/// - ``displayedComponents``
@_documentation(visibility: public)
struct DatePicker<Library: ElementLibrary>: View {
    let node: Node
    
    @Environment(LightpandaRuntime.self) private var lightpanda
    
    @State private var selection: Date = Date()
    
    /// The initial selection as an ISO 8601 date string.
    @_documentation(visibility: public)
    private var initialSelection: Date? {
        node.attributeValue(for: "selection").flatMap { Self.parseISO8601($0) }
    }
    
    /// The start date (inclusive) of the valid date range. Encoded as an ISO 8601 date string.
    @_documentation(visibility: public)
    private var start: Date? {
        node.attributeValue(for: "start").flatMap { Self.parseISO8601($0) }
    }
    
    /// The end date (inclusive) of the valid date range. Encoded as an ISO 8601 date string.
    @_documentation(visibility: public)
    private var end: Date? {
        node.attributeValue(for: "end").flatMap { Self.parseISO8601($0) }
    }
    
    /// Which components of the date to display in the picker. Defaults to all.
    ///
    /// Possible values:
    /// - `hourAndMinute`
    /// - `date`
    @_documentation(visibility: public)
    private var displayedComponents: String? {
        node.attributeValue(for: "displayedComponents")
    }
    
    #if os(iOS) || os(macOS)
    private var datePickerComponents: DatePickerComponents {
        guard let displayedComponents else {
            return [.hourAndMinute, .date]
        }
        switch displayedComponents {
        case "hourAndMinute":
            return .hourAndMinute
        case "date":
            return .date
        default:
            return [.hourAndMinute, .date]
        }
    }
    #endif
    
    var body: some View {
        #if os(iOS) || os(macOS)
        SwiftUI.Group {
            if let start, let end {
                SwiftUI.DatePicker(selection: $selection, in: start...end, displayedComponents: datePickerComponents) {
                    node.children(library: Library.self)
                }
            } else if let start {
                SwiftUI.DatePicker(selection: $selection, in: start..., displayedComponents: datePickerComponents) {
                    node.children(library: Library.self)
                }
            } else if let end {
                SwiftUI.DatePicker(selection: $selection, in: ...end, displayedComponents: datePickerComponents) {
                    node.children(library: Library.self)
                }
            } else {
                SwiftUI.DatePicker(selection: $selection, displayedComponents: datePickerComponents) {
                    node.children(library: Library.self)
                }
            }
        }
        .onAppear {
            if let initialSelection {
                selection = initialSelection
            }
        }
        .onChange(of: selection) { _, newValue in
            Task {
                let isoString = Self.formatISO8601(newValue)
                try await self.node.callFunction(
                    runtime: lightpanda,
                    function: #"""
                    function() {
                        this.value = "\#(isoString)";
                        this.dispatchEvent(new Event("change", { bubbles: true }));
                    }
                    """#
                )
            }
        }
        .task {
            let id = UUID().uuidString
            _ = try? await lightpanda.cdp.addBinding(name: id) { call in
                if let date = Self.parseISO8601(call.payload) {
                    Task { @MainActor in
                        selection = date
                    }
                }
            }
            
            let initialISO = initialSelection.map { Self.formatISO8601($0) } ?? Self.formatISO8601(Date())
            try? await self.node.callFunction(runtime: lightpanda, function: #"""
            function() {
                let internalValue = "\#(initialISO)";
                Object.defineProperty(this, "value", {
                    get() { return internalValue; },
                    set(newValue) {
                        internalValue = newValue;
                        globalThis["\#(id)"](newValue);
                    },
                    configurable: true
                });
            }
            """#)
        }
        #endif
    }
    
    /// Parses an ISO 8601 date string.
    private static func parseISO8601(_ string: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = formatter.date(from: string) {
            return date
        }
        // Try without fractional seconds
        formatter.formatOptions = [.withInternetDateTime]
        if let date = formatter.date(from: string) {
            return date
        }
        // Try date only
        formatter.formatOptions = [.withFullDate]
        return formatter.date(from: string)
    }
    
    /// Formats a date as ISO 8601 string.
    private static func formatISO8601(_ date: Date) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter.string(from: date)
    }
}
