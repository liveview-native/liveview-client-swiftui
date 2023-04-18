//
//  TabView.swift
//
//
//  Created by Carson Katri on 3/2/23.
//

import SwiftUI

/// Container
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct TabView<R: RootRegistry>: View {
    @ObservedElement private var element
    @LiveContext<R> private var context
    
    @LiveBinding(attribute: "selection") private var selection = ""
    
    var body: some View {
        SwiftUI.TabView(selection: $selection) {
            context.buildChildren(of: element)
        }
    }
}
