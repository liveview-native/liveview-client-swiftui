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
    @LiveContext<R> private var context
    
    var body: some View {
        SwiftUI.VSplitView {
            context.buildChildren(of: element)
        }
    }
}
#endif
