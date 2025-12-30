//
//  LazyHGrid.swift
//
//
//  Created by Carson Katri on 2/15/23.
//

import SwiftUI
import LightpandaClient

/// Grid that grows horizontally.
///
/// Use the ``rows`` attribute to configure the presentation of the grid.
///
/// ```html
/// <LazyHGrid
///     rows={[
///         %{ size: %{ fixed: 100 } },
///         %{ size: :flexible },
///         %{ size: %{ adaptive: %{ minimum: 50 } } }
///     ]}
/// >
///     <%= for i <- 1..50 do %>
///         <Text id={i |> Integer.to_string}><%= i %></Text>
///     <% end %>
/// </LazyHGrid>
/// ```
///
/// There are 3 types of grid item:
/// * `fixed(size, spacing, alignment)`: creates a single row that takes up the specified amount of space.
/// * `flexible(minimum, maximum, spacing, alignment)`: creates a single row that fills the available space.
/// * `adaptive(minimum, maximum, spacing, alignment)`: fills the available space with as many rows as will fit.
///
/// ## Attributes
/// * ``rows``
/// * ``alignment``
/// * ``spacing``
/// * ``pinnedViews``
@_documentation(visibility: public)
struct LazyHGrid<Library: ElementLibrary>: View {
    let node: Node
    
    /// Configured rows to fill with the child elements.
    @_documentation(visibility: public)
    private var rows: [GridItem] {
        node.attributeValue(for: "rows", strategy: GridItemParseStrategy()) ?? []
    }
    /// The alignment between rows.
    @_documentation(visibility: public)
    private var alignment: VerticalAlignment {
        node.attributeValue(for: "alignment", strategy: VerticalAlignmentParseStrategy()) ?? .center
    }
    /// The spacing between rows.
    @_documentation(visibility: public)
    private var spacing: CGFloat? {
        node.attributeValue(for: "spacing", strategy: .number).flatMap(CGFloat.init)
    }
    /// Pins section headers/footers.
    ///
    /// See ``LiveViewNative/SwiftUI/PinnedScrollableViews``.
    @_documentation(visibility: public)
    private var pinnedViews: PinnedScrollableViews {
        node.attributeValue(for: "pinnedViews", strategy: PinnedScrollableViewsParseStrategy()) ?? []
    }

    public var body: some View {
        SwiftUI.LazyHGrid(
            rows: rows,
            alignment: alignment,
            spacing: spacing,
            pinnedViews: pinnedViews
        ) {
            node.children(library: Library.self)
        }
    }
}

struct GridItemParseStrategy: ParseStrategy {
    func parse(_ value: String) throws -> [GridItem] {
        // Parse JSON array of grid items
        // Format: [{"size": "flexible"}, {"size": {"fixed": 100}}, {"size": {"adaptive": {"minimum": 50}}}]
        guard let data = value.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]]
        else {
            // Try simple comma-separated format: "flexible, fixed(100), adaptive(50)"
            return try parseSimpleFormat(value)
        }
        
        return json.compactMap { item -> GridItem? in
            guard let size = item["size"] else { return nil }
            
            let spacing = item["spacing"] as? CGFloat
            let alignment = parseAlignment(item["alignment"] as? String)
            
            if let sizeString = size as? String {
                switch sizeString.lowercased() {
                case "flexible":
                    return GridItem(.flexible(), spacing: spacing, alignment: alignment)
                default:
                    return GridItem(.flexible(), spacing: spacing, alignment: alignment)
                }
            } else if let sizeDict = size as? [String: Any] {
                if let fixed = sizeDict["fixed"] as? Double {
                    return GridItem(.fixed(CGFloat(fixed)), spacing: spacing, alignment: alignment)
                } else if let flexibleDict = sizeDict["flexible"] as? [String: Any] {
                    let minimum = (flexibleDict["minimum"] as? Double).flatMap(CGFloat.init) ?? 10
                    let maximum = (flexibleDict["maximum"] as? Double).flatMap(CGFloat.init) ?? .infinity
                    return GridItem(.flexible(minimum: minimum, maximum: maximum), spacing: spacing, alignment: alignment)
                } else if let adaptiveDict = sizeDict["adaptive"] as? [String: Any] {
                    let minimum = (adaptiveDict["minimum"] as? Double).flatMap(CGFloat.init) ?? 10
                    let maximum = (adaptiveDict["maximum"] as? Double).flatMap(CGFloat.init) ?? .infinity
                    return GridItem(.adaptive(minimum: minimum, maximum: maximum), spacing: spacing, alignment: alignment)
                }
            }
            
            return nil
        }
    }
    
    private func parseSimpleFormat(_ value: String) throws -> [GridItem] {
        let items = value.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        return items.compactMap { item -> GridItem? in
            let lowercased = item.lowercased()
            
            if lowercased == "flexible" {
                return GridItem(.flexible())
            } else if lowercased.hasPrefix("fixed(") {
                let numberString = lowercased.dropFirst(6).dropLast()
                if let size = Double(numberString) {
                    return GridItem(.fixed(CGFloat(size)))
                }
            } else if lowercased.hasPrefix("flexible(") {
                let params = lowercased.dropFirst(9).dropLast()
                let parts = params.split(separator: ":").map { $0.trimmingCharacters(in: .whitespaces) }
                if parts.count >= 1, let min = Double(parts[0]) {
                    let max = parts.count >= 2 ? Double(parts[1]) ?? .infinity : .infinity
                    return GridItem(.flexible(minimum: CGFloat(min), maximum: CGFloat(max)))
                }
            } else if lowercased.hasPrefix("adaptive(") {
                let params = lowercased.dropFirst(9).dropLast()
                let parts = params.split(separator: ":").map { $0.trimmingCharacters(in: .whitespaces) }
                if parts.count >= 1, let min = Double(parts[0]) {
                    let max = parts.count >= 2 ? Double(parts[1]) ?? .infinity : .infinity
                    return GridItem(.adaptive(minimum: CGFloat(min), maximum: CGFloat(max)))
                }
            }
            
            // Default to flexible
            return GridItem(.flexible())
        }
    }
    
    private func parseAlignment(_ value: String?) -> Alignment? {
        guard let value = value else { return nil }
        return try? AlignmentParseStrategy().parse(value)
    }
}
