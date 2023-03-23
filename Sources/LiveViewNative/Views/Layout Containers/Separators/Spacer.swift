//
//  Spacer.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 8/15/22.
//

import SwiftUI

/// A view that expands to provide space between other views.
///
/// ```html
/// <VStack>
///     <Text>First</Text>
///     <Spacer min-length="50" />
///     <Text>Second</Text>
/// </VStack>
/// ```
///
/// Within horizontal and vertical stacks, the spacer only grows along the stack's axis.
/// Otherwise, the spacer grows in both axes.
///
/// ## Attributes
/// - ``minLength``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct Spacer: View {
    /// The minimum size of the spacer. If not provided, the minimum length is the system spacing.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("min-length") private var minLength: Double?
    
    public var body: some View {
        SwiftUI.Spacer(minLength: minLength.flatMap(CGFloat.init))
    }
}
