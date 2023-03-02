//
//  TextFieldLink.swift
//  
//
//  Created by Carson Katri on 3/2/23.
//

#if os(watchOS)
import SwiftUI

struct TextFieldLink<R: RootRegistry>: View {
    @ObservedElement var element: ElementNode
    let context: LiveContext<R>
    @FormState var value: String?
    
    init(context: LiveContext<R>) {
        self.context = context
    }
    
    var body: some View {
        SwiftUI.TextFieldLink(
            prompt: element.attributeValue(for: "prompt").flatMap(SwiftUI.Text.init)
        ) {
            context.buildChildren(of: element)
        } onSubmit: { newValue in
            value = newValue
        }
    }
}
#endif
