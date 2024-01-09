//
//  HSplitView.swift
//  
//
//  Created by Carson Katri on 3/2/23.
//

import SwiftUI

/// Container with resizable splits between elements.
///
/// Each element in the container will be in a separate resizable section.
///
/// If the element does not take up all available space, the section will only be able to shrink.
///
/// ```html
/// <HSplitView>
///     <Rectangle fill-color="system-red" />
///     <Rectangle fill-color="system-blue" />
/// </HSplitView>
/// ```
@_documentation(visibility: public)
@available(macOS 13.0, *)
struct HSplitView<R: RootRegistry>: View {
    @ObservedElement private var element
    @LiveContext<R> private var context
    
    var body: some View {
#if os(macOS)
        SwiftUI.HSplitView {
            context.buildChildren(of: element)
        }
#endif
    }
}
