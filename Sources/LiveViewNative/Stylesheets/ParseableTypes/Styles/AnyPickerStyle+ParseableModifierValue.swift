//
//  AnyPickerStyle+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 11/14/23.
//

import SwiftUI
import LiveViewNativeStylesheet

enum AnyPickerStyle: String, CaseIterable, ParseableModifierValue {
    typealias _ParserType = ImplicitStaticMember<Self, EnumParser<Self>>
    
    case automatic
    #if os(iOS) || os(macOS) || os(tvOS) || os(xrOS)
    case menu
    case segmented
    #endif
    #if os(iOS) || os(tvOS) || os(watchOS) || os(xrOS)
    case navigationLink
    #endif
    #if os(iOS) || os(macOS) || os(xrOS)
    case palette
    #endif
    #if os(macOS)
    case radioGroup
    #endif
    #if os(iOS) || os(watchOS) || os(xrOS)
    case wheel
    #endif
}

extension View {
    @_disfavoredOverload
    @ViewBuilder
    func pickerStyle(_ style: AnyPickerStyle) -> some View {
        switch style {
        case .automatic:
            self.pickerStyle(.automatic)
        #if os(iOS) || os(macOS) || os(tvOS) || os(xrOS)
        case .menu:
            if #available(iOS 14, macOS 11, tvOS 17, *) {
                self.pickerStyle(.menu)
            } else {
                self
            }
        case .segmented:
            self.pickerStyle(.segmented)
        #endif
        #if os(iOS) || os(tvOS) || os(watchOS) || os(xrOS)
        case .navigationLink:
            self.pickerStyle(.navigationLink)
        #endif
        #if os(iOS) || os(macOS) || os(xrOS)
        case .palette:
            if #available(iOS 17.0, macOS 14.0, *) {
                self.pickerStyle(.palette)
            } else {
                self
            }
        #endif
        #if os(macOS)
        case .radioGroup:
            self.pickerStyle(.radioGroup)
        #endif
        #if os(iOS) || os(watchOS) || os(xrOS)
        case .wheel:
            self.pickerStyle(.wheel)
        #endif
        }
    }
}
