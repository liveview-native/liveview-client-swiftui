//
//  BackgroundModifier.swift
// LiveViewNative
//
//  Created by May Matyi on 3/17/23.
//

import SwiftUI

struct BackgroundModifier<R: RootRegistry>: ViewModifier, Decodable {
    let alignment: Alignment
    let content: String
    let element: ElementNode
    @LiveContext<R> private var context

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.alignment = try container.decode(Alignment.self, forKey: .alignment)
        self.content = try container.decode(String.self, forKey: .content)
        self.element = decoder.userInfo[.elementNode!] as! ElementNode
    }

    func body(content: Content) -> some View {
        content.background(alignment: alignment) {
            context.buildChildren(of: element, withTagName: self.content, namespace: "background")
        }
    }

    enum CodingKeys: CodingKey {
        case alignment
        case content
    }
}
