//
//  Link.swift
//
//
//  Created by Carson Katri on 2/7/23.
//

import SwiftUI

struct ShareLink<R: CustomRegistry>: View {
    @ObservedElement private var element: ElementNode
    let context: LiveContext<R>
    
    init(element: ElementNode, context: LiveContext<R>) {
        self.context = context
    }
    
    public var body: some View {
        if let item = element.attributeValue(for: "item") {
            let subject = element.attributeValue(for: "subject").flatMap(SwiftUI.Text.init)
            let message = element.attributeValue(for: "message").flatMap(SwiftUI.Text.init)
            if element.children().isEmpty {
                SwiftUI.ShareLink(
                    item: item,
                    subject: subject,
                    message: message
                )
            } else {
                SwiftUI.ShareLink(
                    item: item,
                    subject: subject,
                    message: message
                ) {
                    context.buildChildren(of: element)
                }
            }
        }
    }
}
