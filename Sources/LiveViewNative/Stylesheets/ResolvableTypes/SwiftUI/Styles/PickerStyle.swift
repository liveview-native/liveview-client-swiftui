//
//  PickerStyle.swift
//  LiveViewNative
//
//  Created by Carson Katri on 1/30/25.
//

import SwiftUI
import LiveViewNativeStylesheet
import LiveViewNativeCore

@ASTDecodable("PickerStyle")
enum StylesheetResolvablePickerStyle: StylesheetResolvable, @preconcurrency Decodable {
    case automatic
    case inline
    case menu
    #if os(iOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(macOS, unavailable)
    case navigationLink
    #endif
    #if os(iOS) || os(macOS) || os(visionOS)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    case palette
    #endif
    #if os(macOS)
    @available(iOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @available(visionOS, unavailable)
    case radioGroup
    #endif
    case segmented
    #if os(iOS) || os(visionOS) || os(watchOS)
    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    case wheel
    #endif
}

extension StylesheetResolvablePickerStyle {
    @MainActor func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Self {
        return self
    }
}

extension StylesheetResolvablePickerStyle: @preconcurrency AttributeDecodable {
    nonisolated init(from attribute: Attribute?, on element: ElementNode) throws {
        switch attribute?.value {
        case "automatic":
            self = .automatic
        case "inline":
            self = .inline
        case "menu":
            self = .menu
        #if os(iOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case "navigationLink":
            self = .navigationLink
        #endif
        #if os(iOS) || os(macOS) || os(visionOS)
        case "palette":
            self = .palette
        #endif
        #if os(macOS)
        case "radioGroup":
            self = .radioGroup
        #endif
        case "segmented":
            self = .segmented
        #if os(iOS) || os(visionOS) || os(watchOS)
        case "wheel":
            self = .wheel
        #endif
        default:
            throw AttributeDecodingError.badValue(Self.self)
        }
    }
}

extension View {
    @_disfavoredOverload
    @ViewBuilder
    func pickerStyle(_ style: StylesheetResolvablePickerStyle) -> some View {
        switch style {
        case .automatic:
            self.pickerStyle(DefaultPickerStyle.automatic)
        case .inline:
            self.pickerStyle(InlinePickerStyle.inline)
        case .menu:
            self.pickerStyle(MenuPickerStyle.menu)
        #if os(iOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case .navigationLink:
            self.pickerStyle(NavigationLinkPickerStyle.navigationLink)
        #endif
        #if os(iOS) || os(macOS) || os(visionOS)
        case .palette:
            if #available(iOS 17.0, macOS 14.0, *) {
                self.pickerStyle(PalettePickerStyle.palette)
            } else {
                self
            }
        #endif
        #if os(macOS)
        case .radioGroup:
            self.pickerStyle(RadioGroupPickerStyle.radioGroup)
        #endif
        case .segmented:
            self.pickerStyle(SegmentedPickerStyle.segmented)
        #if os(iOS) || os(visionOS) || os(watchOS)
        case .wheel:
            self.pickerStyle(WheelPickerStyle.wheel)
        #endif
        }
    }
}
