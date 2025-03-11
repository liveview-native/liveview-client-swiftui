//
//  MenuButtonStyle.swift
//  LiveViewNative
//
//  Created by Carson Katri on 3/11/25.
//

#if os(macOS)
import SwiftUI
import LiveViewNativeCore
import LiveViewNativeStylesheet

@ASTDecodable("MenuButtonStyle")
enum StylesheetResolvableMenuButtonStyle: StylesheetResolvable, @preconcurrency Decodable {
    case `default`
    
    func resolve<R>(on element: ElementNode, in context: LiveContext<R>) -> DefaultMenuButtonStyle where R : RootRegistry {
        return DefaultMenuButtonStyle()
    }
}

extension StylesheetResolvableMenuButtonStyle: AttributeDecodable {
    nonisolated init(from attribute: Attribute?, on element: ElementNode) throws {
        self = .default
    }
}
#endif
