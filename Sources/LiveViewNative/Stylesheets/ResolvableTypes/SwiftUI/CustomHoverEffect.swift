//
//  CustomHoverEffect.swift
//  LiveViewNative
//
//  Created by Carson.Katri on 1/30/25.
//

#if os(iOS) || os(tvOS) || os(visionOS)
import SwiftUI
import LiveViewNativeStylesheet
import LiveViewNativeCore

@ASTDecodable("CustomHoverEffect")
@available(iOS 18.0, tvOS 18.0, visionOS 2.0, *)
enum StylesheetResolvableCustomHoverEffect: StylesheetResolvable, CustomHoverEffect {
    case automatic
}

@available(iOS 18.0, tvOS 18.0, visionOS 2.0, *)
extension StylesheetResolvableCustomHoverEffect {
    func body(content: Content) -> some CustomHoverEffect {
        content
    }
    
    func resolve<R>(on element: ElementNode, in context: LiveContext<R>) -> Self where R : RootRegistry {
        return self
    }
}

@available(iOS 18.0, tvOS 18.0, visionOS 2.0, *)
extension StylesheetResolvableCustomHoverEffect: AttributeDecodable {
    nonisolated init(from attribute: Attribute?, on element: ElementNode) throws {
        fatalError()
    }
}
#endif
