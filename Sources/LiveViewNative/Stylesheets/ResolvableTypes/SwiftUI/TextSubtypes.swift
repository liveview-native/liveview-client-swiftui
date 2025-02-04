//
//  Text.swift
//  LiveViewNative
//
//  Created by Carson.Katri on 1/30/25.
//

import SwiftUI
import LiveViewNativeStylesheet
import LiveViewNativeCore

//@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
//extension SwiftUI.Text.Layout.Run {
//    @ASTDecodable("Run")
//    enum Resolvable: StylesheetResolvable {
//        case __constant(SwiftUI.Text.Layout.Run)
//    }
//}
//
//@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
//extension SwiftUI.Text.Layout.Run.Resolvable {
//    @MainActor
//    func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> SwiftUI.Text.Layout.Run {
//        switch self {
//        case let .__constant(value):
//            return value
//        }
//    }
//}

@ASTDecodable("Pattern")
enum TextLineStylePatternResolvable: StylesheetResolvable, @preconcurrency Decodable {
    case __constant(SwiftUI.Text.LineStyle.Pattern)
    case solid
    case dot
    case dash
    case dashDot
    case dashDotDot
}
extension SwiftUI.Text.LineStyle.Pattern {
    typealias Resolvable = TextLineStylePatternResolvable
}

extension TextLineStylePatternResolvable {
    @MainActor func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> SwiftUI.Text.LineStyle.Pattern {
        switch self {
        case let .__constant(value):
            return value
        case .solid:
            return .solid
        case .dot:
            return .dot
        case .dash:
            return .dash
        case .dashDot:
            return .dashDot
        case .dashDotDot:
            return .dashDotDot
        }
    }
}

@ASTDecodable("TextAttribute")
enum StylesheetResolvableTextAttribute: @preconcurrency TextAttribute, StylesheetResolvable, @preconcurrency Decodable, @preconcurrency AttributeDecodable {
    case __never
}

extension StylesheetResolvableTextAttribute {
    @MainActor
    func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Self {
        return self
    }
}

extension StylesheetResolvableTextAttribute {
    init(from attribute: Attribute?, on element: ElementNode) throws {
        fatalError("'TextAttribute' is not supported")
    }
}
