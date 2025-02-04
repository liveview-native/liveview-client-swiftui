//
//  StylesheetResolvableShape.swift
//  LiveViewNative
//
//  Created by Carson.Katri on 1/30/25.
//

import SwiftUI
import LiveViewNativeStylesheet
import LiveViewNativeCore

@ASTDecodable("Shape")
enum StylesheetResolvableShape: SwiftUI.Shape, StylesheetResolvable, @preconcurrency Decodable {
    case circle
    
    nonisolated func path(in rect: CGRect) -> Path {
        SwiftUI.Circle().path(in: rect)
    }
    
    nonisolated func sizeThatFits(_ proposal: ProposedViewSize) -> CGSize {
        SwiftUI.Circle().sizeThatFits(proposal)
    }
}

extension StylesheetResolvableShape {
    @MainActor func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Self {
        return self
    }
}

extension StylesheetResolvableShape: AttributeDecodable {
    nonisolated init(from attribute: Attribute?, on element: ElementNode) throws {
        switch attribute?.value {
        case "circle":
            self = .circle
        default:
            throw AttributeDecodingError.badValue(Self.self)
        }
    }
}

@ASTDecodable("InsettableShape")
enum StylesheetResolvableInsettableShape: InsettableShape, StylesheetResolvable, @preconcurrency Decodable {
    case circle
    
    nonisolated func path(in rect: CGRect) -> Path {
        SwiftUI.Circle().path(in: rect)
    }
    
    nonisolated func sizeThatFits(_ proposal: ProposedViewSize) -> CGSize {
        SwiftUI.Circle().sizeThatFits(proposal)
    }
    
    nonisolated func inset(by amount: CGFloat) -> some InsettableShape {
        SwiftUI.Circle().inset(by: amount)
    }
}

extension StylesheetResolvableInsettableShape {
    @MainActor func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Self {
        return self
    }
}

extension StylesheetResolvableInsettableShape: @preconcurrency AttributeDecodable {
    nonisolated init(from attribute: Attribute?, on element: ElementNode) throws {
        switch attribute?.value {
        case "circle":
            self = .circle
        default:
            throw AttributeDecodingError.badValue(Self.self)
        }
    }
}
