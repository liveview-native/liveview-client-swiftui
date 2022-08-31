//
//  PhxZStack.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 8/31/22.
//

import SwiftUI

struct PhxZStack<R: CustomRegistry>: View {
    private let element: Element
    private let context: LiveContext<R>
    private let alignment: Alignment
    
    init(element: Element, context: LiveContext<R>) {
        self.element = element
        self.context = context
        if let s = element.attrIfPresent("alignment"), let alignment = Alignment(string: s) {
            self.alignment = alignment
        } else {
            self.alignment = .center
        }
    }

    public var body: some View {
        ZStack(alignment: alignment) {
            context.buildChildren(of: element)
        }
    }
}
