//
//  ListStyle.swift
//  LiveViewNative
//
//  Created by Carson Katri on 1/30/25.
//

import SwiftUI
import LiveViewNativeStylesheet
import LiveViewNativeCore

@ASTDecodable("ListStyle")
enum StylesheetResolvableListStyle: StylesheetResolvable, @preconcurrency Decodable {
    case automatic
    #if os(macOS)
    @available(iOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @available(visionOS, unavailable)
    case bordered
    #endif
    #if os(watchOS)
    @available(iOS, unavailable)
    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    @available(visionOS, unavailable)
    case carousel
    @available(iOS, unavailable)
    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    @available(visionOS, unavailable)
    case elliptical
    #endif
    #if os(iOS) || os(tvOS) || os(visionOS)
    @available(macOS, unavailable)
    @available(watchOS, unavailable)
    case grouped
    @available(macOS, unavailable)
    @available(watchOS, unavailable)
    case inset
    @available(macOS, unavailable)
    @available(watchOS, unavailable)
    case insetGrouped
    #endif
    case plain
    case sidebar
}

extension StylesheetResolvableListStyle {
    @MainActor func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Self {
        return self
    }
}

extension View {
    @_disfavoredOverload
    @ViewBuilder
    func listStyle(_ style: StylesheetResolvableListStyle) -> some View {
        switch style {
        case .automatic:
            self.listStyle(.automatic)
        #if os(macOS)
        case .bordered:
            self.listStyle(.bordered)
        #endif
        #if os(watchOS)
        case .carousel:
            self.listStyle(.carousel)
        case .elliptical:
            self.listStyle(.elliptical)
        #endif
        #if os(iOS) || os(tvOS) || os(visionOS)
        case .grouped:
            self.listStyle(.grouped)
        case .inset:
            self.listStyle(.inset)
        case .insetGrouped:
            self.listStyle(.insetGrouped)
        #endif
        case .plain:
            self.listStyle(.plain)
        case .sidebar:
            self.listStyle(.sidebar)
        }
    }
}

extension StylesheetResolvableListStyle: @preconcurrency AttributeDecodable {
    nonisolated init(from attribute: Attribute?, on element: ElementNode) throws {
        switch attribute?.value {
        case "automatic":
            self = .automatic
        #if os(macOS)
        case "bordered":
            self = .bordered
        #endif
        #if os(watchOS)
        case "carousel":
            self = .carousel
        case "elliptical":
            self = .elliptical
        #endif
        #if os(iOS) || os(tvOS) || os(visionOS)
        case "grouped":
            self = .grouped
        case "inset":
            self = .inset
        case "insetGrouped":
            self = .insetGrouped
        #endif
        case "plain":
            self = .plain
        case "sidebar":
            self = .sidebar
        default:
            throw AttributeDecodingError.badValue(Self.self)
        }
    }
}
