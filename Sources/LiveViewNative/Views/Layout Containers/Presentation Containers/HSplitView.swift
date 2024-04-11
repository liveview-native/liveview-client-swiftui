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
///     <Rectangle fillColor="system-red" />
///     <Rectangle fillColor="system-blue" />
/// </HSplitView>
/// ```
@_documentation(visibility: public)
@available(macOS 13.0, *)
@LiveElement
struct HSplitView<Root: RootRegistry>: View {
    var body: some View {
#if os(macOS)
        SwiftUI.HSplitView {
            $liveElement.children()
        }
#endif
    }
}
