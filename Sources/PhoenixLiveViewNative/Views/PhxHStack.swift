//
//  PhxHStack.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 8/31/22.
//

import SwiftUI

/// `<hstack>`, lays out children in a horizontal line.
public struct PhxHStack<R: CustomRegistry>: View {
    private let element: Element
    private let context: LiveContext<R>
    private let alignment: VerticalAlignment
    
    init(element: Element, context: LiveContext<R>) {
        self.element = element
        self.context = context
        switch element.attrIfPresent("alignment") {
        case nil, "center":
            self.alignment = .center
        case "top":
            self.alignment = .top
        case "bottom":
            self.alignment = .bottom
        default:
            fatalError("Invalid value '\(try! element.attr("alignment"))' for alignment attribute of <hstack>")
        }
    }

    public var body: some View {
        HStack(alignment: alignment) {
            context.buildChildren(of: element)
        }
    }
}
