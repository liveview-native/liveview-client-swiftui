//
//  TextScaleModifier.swift
//
//
//  Created by Carson Katri on 2/21/24.
//

import SwiftUI
import LiveViewNativeStylesheet

@ParseableExpression
struct _TextScaleModifier<R: RootRegistry>: TextModifier {
    static var name: String { "textScale" }

    let scale: Any
    let isEnabled: AttributeReference<Bool>

    @ObservedElement private var element
    @LiveContext<R> private var context

    #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
    @available(tvOS 17.0,iOS 17.0,macOS 14.0,watchOS 10.0, *)
    init(_ scale: SwiftUI.Text.Scale, isEnabled: AttributeReference<Bool> = .init(storage: .constant(true))) {
        self.scale = scale
        self.isEnabled = isEnabled
    }
    #endif

    func body(content: Content) -> some View {
        #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
        if #available(tvOS 17.0,iOS 17.0,macOS 14.0,watchOS 10.0, *) {
            content
                .textScale(scale as! SwiftUI.Text.Scale, isEnabled: isEnabled.resolve(on: element, in: context))
        } else {
            content
        }
        #endif
    }
    
    func apply(to text: SwiftUI.Text, on element: ElementNode) -> SwiftUI.Text {
        #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
        if #available(tvOS 17.0,iOS 17.0,macOS 14.0,watchOS 10.0, *) {
            return text
                .textScale(scale as! SwiftUI.Text.Scale, isEnabled: isEnabled.resolve(on: element))
        } else {
            return text
        }
        #endif
    }
}
