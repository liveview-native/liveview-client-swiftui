//
//  Stacks.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI
import SwiftSoup

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

/// `<zstack>`, lays out children on top of each other, from back to front.
public struct PhxZStack<R: CustomRegistry>: View {
    var element: Element
    var context: LiveContext<R>

    public var body: some View {
        ZStack {
            context.buildChildren(of: element)
        }
    }
}
