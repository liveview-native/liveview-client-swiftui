//
//  PresentationDetentsModifier.swift
//
//
//  Created by Carson Katri on 11/22/23.
//

import SwiftUI
import LiveViewNativeStylesheet

// manual implementation
// `PresentationDetent` cannot be encoded, and therefore is not compatible with `ChangeTracked`.
/// See [`SwiftUI.View/presentationDetents(_:)`](https://developer.apple.com/documentation/swiftui/view/presentationDetents(_:)) for more details on this ViewModifier.
///
/// ### presentationDetents(_:)
/// - `detents`: Array of ``SwiftUI/PresentationDetent`` (required)
///
/// See [`SwiftUI.View/presentationDetents(_:)`](https://developer.apple.com/documentation/swiftui/view/presentationDetents(_:)) for more details on this ViewModifier.
///
/// Example:
///
/// ```elixir
/// # stylesheet
/// "example" do
///   presentationDetents([.medium, .large])
/// end
/// ```
@_documentation(visibility: public)
@ASTDecodable("presentationDetents")
struct _PresentationDetentsModifier: ViewModifier {
    let detents: Set<PresentationDetent>
    
    init(_ detents: Set<PresentationDetent>) {
        self.detents = detents
    }
    
    func body(content: Content) -> some View {
        content.presentationDetents(detents)
    }
}
