//
//  AnyControlGroupStyle+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 11/14/23.
//

import SwiftUI
import LiveViewNativeStylesheet

#if !os(watchOS)
enum AnyControlGroupStyle: String, CaseIterable, ParseableModifierValue, ControlGroupStyle {
    typealias _ParserType = ImplicitStaticMember<Self, EnumParser<Self>>
    
    case automatic
    #if os(iOS) || os(macOS) || os(xrOS)
    case compactMenu
    case navigation
    case palette
    #endif
    #if os(iOS) || os(macOS) || os(tvOS) || os(xrOS)
    case menu
    #endif
    
    func makeBody(configuration: Configuration) -> some View {
        if #available(iOS 16, macOS 13, tvOS 17, watchOS 9, *) {
            let controlGroup = SwiftUI.ControlGroup(configuration)
            switch self {
            case .automatic:
                controlGroup.controlGroupStyle(.automatic)
            #if os(iOS) || os(macOS) || os(xrOS)
            case .compactMenu:
                if #available(iOS 16.4, macOS 13.3, *) {
                    controlGroup.controlGroupStyle(.compactMenu)
                } else {
                    controlGroup
                }
            case .navigation:
                controlGroup.controlGroupStyle(.navigation)
            case .palette:
                if #available(iOS 17.0, macOS 14.0, *) {
                    controlGroup.controlGroupStyle(.palette)
                } else {
                    controlGroup
                }
            #endif
            #if os(iOS) || os(macOS) || os(tvOS) || os(xrOS)
            case .menu:
                if #available(iOS 16.4, macOS 13.3, *) {
                    controlGroup.controlGroupStyle(.menu)
                } else {
                    controlGroup
                }
            #endif
            }
        }
    }
}
#endif
