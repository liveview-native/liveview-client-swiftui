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
    var node: Node
    
    @Environment(LightpandaRuntime.self) private var lightpanda
    @State private var dates: Set<DateComponents> = []
    
    /// The current selection binding that syncs with JS.
    private var selection: Binding<Set<DateComponents>> {
        Binding(
            get: { dates },
            set: { newValue in
                dates = newValue
                let dateStrings = newValue.compactMap { components -> String? in
                    guard let date = Calendar.current.date(from: components) else { return nil }
                    return Self.formatDate(date)
                }
                let jsonArray = String(data: try! JSONEncoder().encode(dateStrings), encoding: .utf8)!
                node.attributes["selection"] = jsonArray
                Task {
                    try? await self.node.callFunction(
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
        )
    }
    
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
    
    var body: some View {
        #if os(iOS)
        SwiftUI.Group {
            if let start, let end {
                SwiftUI.MultiDatePicker(selection: selection, in: start..<end) {
                    node.children(library: Library.self)
                }
            } else if let start {
                SwiftUI.MultiDatePicker(selection: selection, in: start...) {
                    node.children(library: Library.self)
                }
            } else if let end {
                SwiftUI.MultiDatePicker(selection: selection, in: ..<end) {
                    node.children(library: Library.self)
                }
            } else {
                SwiftUI.MultiDatePicker(selection: selection) {
                    node.children(library: Library.self)
                }
            }
        }
        .onAppear {
            // Initialize from node attribute
            if let value = node.attributes["selection"],
               let data = value.data(using: .utf8),
               let array = try? JSONDecoder().decode([String].self, from: data) {
                dates = Set(array.compactMap { dateString -> DateComponents? in
                    guard let date = Self.parseDate(dateString) else { return nil }
                    return Calendar.current.dateComponents([.year, .month, .day], from: date)
                })
            }
        }
        .task {
            let id = UUID().uuidString
            _ = try? await lightpanda.cdp.addBinding(name: id) { [weak node] call in
                guard let node else { return }
                Task { @MainActor in
                    node.attributes["selection"] = call.payload
                    // Update local state from JS
                    if let data = call.payload.data(using: .utf8),
                       let array = try? JSONDecoder().decode([String].self, from: data) {
                        dates = Set(array.compactMap { dateString -> DateComponents? in
                            guard let date = Self.parseDate(dateString) else { return nil }
                            return Calendar.current.dateComponents([.year, .month, .day], from: date)
                        })
                    }
                }
            }
            
            let initialJSON = node.attributes["selection"] ?? "[]"
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
