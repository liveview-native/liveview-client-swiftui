//
//  HSplitView.swift
//  
//
//  Created by Carson Katri on 3/2/23.
//

#if os(macOS)
import SwiftUI

struct HSplitView<R: RootRegistry>: View {
    @ObservedElement private var element
    @LiveContext<R> private var context
    
    var body: some View {
        SwiftUI.HSplitView {
            context.buildChildren(of: element)
        }
    }
}
#endif
