//
//  FontDesignModifier.swift
//
//
//  Created by Carson Katri on 2/21/24.
//

import SwiftUI
import LiveViewNativeStylesheet

@ParseableExpression
struct _FontDesignModifier<R: RootRegistry>: TextModifier {
    static var name: String { "fontDesign" }
    
    let design: Any?

    #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
    @available(watchOS 9.1,tvOS 16.1,iOS 16.1,macOS 13.0, *)
    init(_ design: SwiftUI.Font.Design?) {
        self.design = design
    }
    #endif

    func body(content: Content) -> some View {
        #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
        if #available(watchOS 9.1,tvOS 16.1,iOS 16.1,macOS 13.0, *) {
            content.fontDesign(design as? SwiftUI.Font.Design)
        } else {
            content
        }
        #endif
    }
    
    func apply(to text: SwiftUI.Text, on element: ElementNode) -> SwiftUI.Text {
        #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
        if #available(watchOS 9.1,tvOS 16.1,iOS 16.1,macOS 13.0, *) {
            return text.fontDesign(design as? SwiftUI.Font.Design)
        } else {
            return text
        }
        #endif
    }
}
