//
//  Gesture.swift
//  LiveViewNative
//
//  Created by Carson Katri on 1/30/25.
//

import SwiftUI
import LiveViewNativeStylesheet
import LiveViewNativeCore

@ASTDecodable("Gesture")
enum StylesheetResolvableGesture: @preconcurrency Gesture, StylesheetResolvable, @preconcurrency Decodable {
    case drag
    
    var body: some Gesture {
        DragGesture()
    }
}

extension StylesheetResolvableGesture {
    @MainActor func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Self {
        return self
    }
}

extension StylesheetResolvableGesture: @preconcurrency AttributeDecodable {
    nonisolated init(from attribute: Attribute?, on element: ElementNode) throws {
        fatalError()
    }
}

@ASTDecodable("UIGestureRecognizerRepresentable")
enum StylesheetResolvableUIGestureRecognizerRepresentable: @preconcurrency UIGestureRecognizerRepresentable, StylesheetResolvable, @preconcurrency Decodable {
    case drag
    
    func makeUIGestureRecognizer(context: Context) -> some UIGestureRecognizer {
        UISwipeGestureRecognizer()
    }
}

extension StylesheetResolvableUIGestureRecognizerRepresentable {
    @MainActor
    func resolve<R>(on element: ElementNode, in context: LiveContext<R>) -> Self where R : RootRegistry {
        return self
    }
}

extension StylesheetResolvableUIGestureRecognizerRepresentable: @preconcurrency AttributeDecodable {
    nonisolated init(from attribute: Attribute?, on element: ElementNode) throws {
        fatalError()
    }
}
