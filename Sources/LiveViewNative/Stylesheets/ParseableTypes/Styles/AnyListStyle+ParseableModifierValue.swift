//
//  AnyListStyle+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 11/14/23.
//

import SwiftUI
import LiveViewNativeStylesheet

enum AnyListStyle: String, CaseIterable, ParseableModifierValue {
    typealias _ParserType = ImplicitStaticMember<Self, EnumParser<Self>>
    
    case automatic
    case plain
    #if os(watchOS)
    case carousel
    case elliptical
    #endif
    #if os(macOS)
    case bordered
    #endif
    #if os(iOS) || os(tvOS) || os(visionOS)
    case grouped
    #endif
    #if os(iOS) || os(visionOS)
    case insetGrouped
    #endif
    #if os(iOS) || os(macOS) || os(visionOS)
    case inset
    case sidebar
    #endif
}

extension View {
    @_disfavoredOverload
    @ViewBuilder
    func listStyle(_ style: AnyListStyle) -> some View {
        switch style {
        case .automatic:
            self.listStyle(.automatic)
        case .plain:
            self.listStyle(.plain)
        #if os(watchOS)
        case .carousel:
            self.listStyle(.carousel)
        case .elliptical:
            self.listStyle(.elliptical)
        #endif
        #if os(macOS)
        case .bordered:
            self.listStyle(.bordered)
        #endif
        #if os(iOS) || os(tvOS) || os(visionOS)
        case .grouped:
            self.listStyle(.grouped)
        #endif
        #if os(iOS) || os(visionOS)
        case .insetGrouped:
            self.listStyle(.insetGrouped)
        #endif
        #if os(iOS) || os(macOS) || os(visionOS)
        case .inset:
            self.listStyle(.inset)
        case .sidebar:
            self.listStyle(.sidebar)
        #endif
        }
    }
}
