//
//  ZStack.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 8/31/22.
//

import SwiftUI

/// A container that lays out elements on top of each other, back to front.
///
/// ```html
/// <ZStack>
///     <Text>Back</Text>
///     <Text>Front</Text>
/// </ZStack>
/// ```
///
/// ## Attributes
/// - ``alignment``
@_documentation(visibility: public)
@LiveElement
struct ZStack<Root: RootRegistry>: View {
    /// The alignment in both axes of views within the stack. Defaults to center-aligned.
    ///
    /// See ``LiveViewNative/SwiftUI/Alignment``.
    @_documentation(visibility: public)
    private var alignment: Alignment = .center
    
    public var body: some View {
        SwiftUI.ZStack(alignment: alignment) {
            $liveElement.children()
        }
    }
}
