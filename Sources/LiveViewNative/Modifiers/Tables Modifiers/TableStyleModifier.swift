//
//  TableStyleModifier.swift
//  LiveViewNative
//
//  Created by Dylan.Ginsburg on 5/23/23.
//

import SwiftUI

/// Sets the style for tables within this view.
///
/// See ``TableStyle`` for a list of possible values.
///
/// ```html
/// <Table modifiers={table_style(:inset)}
///     ...
/// </Table>
/// ```
///
/// ## Arguments
/// * ``style``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(iOS 16.0, macOS 13.0, *)
struct TableStyleModifier: ViewModifier, Decodable {
    /// A type that applies a custom appearance to all tables within a view.
    ///
    /// See ``TableStyle`` for the list of possible values.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let style: TableStyle

    func body(content: Content) -> some View {
        #if os(watchOS)
        content
        #else
        switch style {
        case .automatic:
            content.tableStyle(.automatic)
        case .inset:
            content.tableStyle(.inset)
        case .insetAlternatesRowBackgrounds:
            content
                #if os(macOS)
                .tableStyle(.inset(alternatesRowBackgrounds: true))
                #endif
        case .bordered:
            content
                #if os(macOS)
                .tableStyle(.bordered)
                #endif
        case .borderedAlternatesRowBackgrounds:
            content
                #if os(macOS)
                .tableStyle(.bordered(alternatesRowBackgrounds: true))
                #endif
        }
        #endif
    }
}

/// A style to apply to all tables with the ``TableStyleModifier`` modifier.
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(iOS 16.0, macOS 13.0, *)
private enum TableStyle: String, Decodable {
    /// The default table style in the current context.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case automatic

    /// The table style that describes the behavior and appearance of a table with its content and selection inset from the table edges.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case inset

    /// The table style that describes the behavior and appearance of a table with its content and selection inset from the table edges. Alternates backgrounds to help visually distinguish them from each other.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @available(macOS 13.0, *)
    case insetAlternatesRowBackgrounds = "inset_alternates_row_backgrounds"

    /// The table style that describes the behavior and appearance of a table with standard border.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @available(macOS 13.0, *)
    case bordered

    /// The table style that describes the behavior and appearance of a table with standard border. Alternates backgrounds to help visually distinguish them from each other.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @available(macOS 13.0, *)
    case borderedAlternatesRowBackgrounds = "bordered_alternates_row_backgrounds"
}
