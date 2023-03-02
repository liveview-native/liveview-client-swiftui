//
//  VSplitView.swift
//
//
//  Created by Carson Katri on 3/2/23.
//

#if os(macOS)
import SwiftUI

struct VSplitView<R: RootRegistry>: View {
    @ObservedElement private var element
    let context: LiveContext<R>
    
    init(context: LiveContext<R>) {
        self.context = context
    }
    
    var body: some View {
        SwiftUI.VSplitView {
            context.buildChildren(of: element)
        }
    }
}
#endif
