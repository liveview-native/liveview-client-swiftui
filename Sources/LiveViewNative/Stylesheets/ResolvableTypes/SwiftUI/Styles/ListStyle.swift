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
    #endif
    #if os(iOS) || os(macOS) || os(visionOS)
    @available(watchOS, unavailable)
    @available(tvOS, unavailable)
    case inset
    #endif
    #if os(iOS) || os(visionOS)
    @available(macOS, unavailable)
    @available(watchOS, unavailable)
    @available(tvOS, unavailable)
    case insetGrouped
    #endif
    case plain
    #if os(iOS) || os(macOS) || os(visionOS)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    case sidebar
    #endif
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
        #endif
        #if os(iOS) || os(macOS)
        case .inset:
            self.listStyle(.inset)
            
        #if os(iOS) || os(visionOS)
        case .insetGrouped:
            self.listStyle(.insetGrouped)
        #endif
            
        #endif
        case .plain:
            self.listStyle(.plain)
        #if os(iOS) || os(macOS) || os(visionOS)
        case .sidebar:
            self.listStyle(.sidebar)
        #endif
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
        #endif
        #if os(iOS) || os(macOS) || os(visionOS)
        case "inset":
            self = .inset
        #endif
        #if os(iOS) || os(visionOS)
        case "insetGrouped":
            self = .insetGrouped
        #endif
        case "plain":
            self = .plain
        #if os(iOS) || os(macOS) || os(visionOS)
        case "sidebar":
            self = .sidebar
        #endif
        default:
            throw AttributeDecodingError.badValue(Self.self)
        }
    }
}
