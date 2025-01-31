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
enum StylesheetResolvableGesture: Gesture, StylesheetResolvable {
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

extension StylesheetResolvableGesture: AttributeDecodable {
    nonisolated init(from attribute: Attribute?, on element: ElementNode) throws {
        fatalError()
    }
}

@ASTDecodable("UIGestureRecognizerRepresentable")
enum StylesheetResolvableUIGestureRecognizerRepresentable: UIGestureRecognizerRepresentable, StylesheetResolvable {
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

extension StylesheetResolvableUIGestureRecognizerRepresentable: AttributeDecodable {
    nonisolated init(from attribute: Attribute?, on element: ElementNode) throws {
        fatalError()
    }
}
