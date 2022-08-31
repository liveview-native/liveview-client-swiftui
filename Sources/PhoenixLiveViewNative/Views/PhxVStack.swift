//
//  PhxVStack.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 8/31/22.
//

import SwiftUI

/// `<vstack>`, lays out children in a vertical line
public struct PhxVStack<R: CustomRegistry>: View {
    private let element: Element
    private let context: LiveContext<R>
    private let alignment: HorizontalAlignment
    
    init(element: Element, context: LiveContext<R>) {
        self.element = element
        self.context = context
        switch element.attrIfPresent("alignment") {
        case nil, "center":
            self.alignment = .center
        case "leading":
            self.alignment = .leading
        case "trailing":
            self.alignment = .trailing
        default:
            fatalError("Invalid value '\(try! element.attr("alignment"))' for alignment attribute of <vstack>")
        }
    }

    public var body: some View {
        VStack(alignment: alignment) {
            context.buildChildren(of: element)
        }
    }
}
