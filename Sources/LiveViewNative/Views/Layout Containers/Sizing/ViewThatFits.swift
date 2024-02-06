//
//  ViewThatFits.swift
//
//
//  Created by Carson Katri on 2/21/23.
//

import SwiftUI

/// Chooses the first child that fits in the available space.
///
/// Child elements are evaluated in order, and the first child that fits in the available space along ``axes`` is displayed.
///
/// ```html
/// <ViewThatFits>
///     <Text>Long text content ... </Text>
///     <Image systemName="doc.text" />
/// </ViewThatFits>
/// ```
///
/// In the above example, if the text content is too large to fit on screen the icon will be displayed instead.
///
/// ## Attributes
/// * ``axes``
@_documentation(visibility: public)
struct ViewThatFits<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    @LiveContext<R> private var context
    
    /// The axes to check each child's size along. Defaults to `all`.
    ///
    /// See ``LiveViewNative/SwiftUI/Axis/Set``
    @_documentation(visibility: public)
    @Attribute("axes") private var axes: Axis.Set = [.horizontal, .vertical]
    
    public var body: some View {
        SwiftUI.ViewThatFits(
            in: axes
        ) {
            context.buildChildren(of: element)
        }
    }
}
