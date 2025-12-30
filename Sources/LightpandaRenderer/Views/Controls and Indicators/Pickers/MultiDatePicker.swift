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
/// <MultiDatePicker start="2023-01-01" end="2023-02-01">
///     <Text>Pick as many dates as you like!</Text>
/// </MultiDatePicker>
/// ```
///
/// The element's children are used as the control's label.
///
/// The value is a JSON array of date strings in the form "yyyy-MM-dd".
///
/// ## Attributes
/// - ``selection``
/// - ``start``
/// - ``end``
@_documentation(visibility: public)
@available(iOS 16.0, *)
struct MultiDatePicker<Library: ElementLibrary>: View {
    let node: Node
    
    @Environment(LightpandaRuntime.self) private var lightpanda
    
    @State private var selection: Set<DateComponents> = []
    
    /// The start date (inclusive) of the picker's range.
    @_documentation(visibility: public)
    private var start: Date? {
        node.attributeValue(for: "start").flatMap { Self.parseDate($0) }
    }
    
    /// The end date (**exclusive**) of the picker's range.
    @_documentation(visibility: public)
    private var end: Date? {
        node.attributeValue(for: "end").flatMap { Self.parseDate($0) }
    }
    
    /// Initial selection as a JSON array of date strings.
    @_documentation(visibility: public)
    private var initialSelection: [String]? {
        guard let value = node.attributeValue(for: "selection"),
              let data = value.data(using: .utf8),
              let array = try? JSONDecoder().decode([String].self, from: data) else {
            return nil
        }
        return array
    }
    
    var body: some View {
        #if os(iOS)
        SwiftUI.Group {
            if let start, let end {
                SwiftUI.MultiDatePicker(selection: $selection, in: start..<end) {
                    node.children(library: Library.self)
                }
            } else if let start {
                SwiftUI.MultiDatePicker(selection: $selection, in: start...) {
                    node.children(library: Library.self)
                }
            } else if let end {
                SwiftUI.MultiDatePicker(selection: $selection, in: ..<end) {
                    node.children(library: Library.self)
                }
            } else {
                SwiftUI.MultiDatePicker(selection: $selection) {
                    node.children(library: Library.self)
                }
            }
        }
        .onAppear {
            if let initialSelection {
                selection = Set(initialSelection.compactMap { dateString -> DateComponents? in
                    guard let date = Self.parseDate(dateString) else { return nil }
                    return Calendar.current.dateComponents([.year, .month, .day], from: date)
                })
            }
        }
        .onChange(of: selection) { _, newValue in
            Task {
                let dateStrings = newValue.compactMap { components -> String? in
                    guard let date = Calendar.current.date(from: components) else { return nil }
                    return Self.formatDate(date)
                }
                let jsonArray = String(data: try! JSONEncoder().encode(dateStrings), encoding: .utf8)!
                try await self.node.callFunction(
                    runtime: lightpanda,
                    function: #"""
                    function() {
                        this.value = \#(jsonArray);
                        this.dispatchEvent(new Event("change", { bubbles: true }));
                    }
                    """#
                )
            }
        }
        .task {
            let id = UUID().uuidString
            _ = try? await lightpanda.cdp.addBinding(name: id) { call in
                guard let data = call.payload.data(using: .utf8),
                      let dateStrings = try? JSONDecoder().decode([String].self, from: data) else {
                    return
                }
                Task { @MainActor in
                    selection = Set(dateStrings.compactMap { dateString -> DateComponents? in
                        guard let date = Self.parseDate(dateString) else { return nil }
                        return Calendar.current.dateComponents([.year, .month, .day], from: date)
                    })
                }
            }
            
            let initialJSON = initialSelection.map { String(data: try! JSONEncoder().encode($0), encoding: .utf8)! } ?? "[]"
            try? await self.node.callFunction(runtime: lightpanda, function: #"""
            function() {
                let internalValue = \#(initialJSON);
                Object.defineProperty(this, "value", {
                    get() { return internalValue; },
                    set(newValue) {
                        internalValue = newValue;
                        globalThis["\#(id)"](JSON.stringify(newValue));
                    },
                    configurable: true
                });
            }
            """#)
        }
        #endif
    }
    
    /// Parses a date string in yyyy-MM-dd format.
    private static func parseDate(_ string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.date(from: string)
    }
    
    /// Formats a date as yyyy-MM-dd string.
    private static func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: date)
    }
}
