//
//  WindowStyle.swift
//  LiveViewNative
//
//  Created by Carson Katri on 2/20/25.
//

#if os(macOS) || os(visionOS)
import SwiftUI
import LiveViewNativeStylesheet
import LiveViewNativeCore

@ASTDecodable("WindowStyle")
enum StylesheetResolvableWindowStyle: StylesheetResolvable, @preconcurrency Decodable, @preconcurrency AttributeDecodable {
    case automatic
    case hiddenTitleBar
    case plain
    case titleBar
    
    #if os(visionOS)
    @available(visionOS 1, *)
    @available(macOS, unavailable)
    case volumetric
    #endif
}

extension StylesheetResolvableWindowStyle {
    init(from attribute: Attribute?, on element: ElementNode) throws {
        switch attribute?.value {
        case "automatic":
            self = .automatic
        case "hiddenTitleBar":
            self = .hiddenTitleBar
        case "plain":
            self = .plain
        case "titleBar":
            self = .titleBar
        #if os(visionOS)
        case "volumetric":
            self = .volumetric
        #endif
        default:
            throw AttributeDecodingError.badValue(Self.self)
        }
    }
    
    func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Self {
        return self
    }
}

extension View {
    @_disfavoredOverload
    @ViewBuilder
    func presentedWindowStyle(_ style: StylesheetResolvableWindowStyle) -> some View {
        switch style {
        case .automatic:
            self.presentedWindowStyle(DefaultWindowStyle.automatic)
        case .hiddenTitleBar:
            self.presentedWindowStyle(HiddenTitleBarWindowStyle.hiddenTitleBar)
        case .plain:
            if #available(macOS 15.0, *) {
                self.presentedWindowStyle(PlainWindowStyle.plain)
            } else {
                self
            }
        case .titleBar:
            self.presentedWindowStyle(TitleBarWindowStyle.titleBar)
        #if os(visionOS)
        case .volumetric:
            self.presentedWindowStyle(VolumetricWindowStyle.volumetric)
        #endif
        }
    }
}
#endif
