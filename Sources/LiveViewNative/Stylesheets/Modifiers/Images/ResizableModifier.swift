//
//  ResizableModifier.swift
//
//
//  Created by Carson Katri on 11/2/23.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.Image/resizable(capInsets:resizingMode:)`](https://developer.apple.com/documentation/swiftui/image/resizable(capInsets:resizingMode:)) for more details on this ViewModifier.
///
/// ### resizable(capInsets:resizingMode:)
/// - `capInsets`: ``SwiftUI/EdgeInsets``
/// - `resizingMode`: ``SwiftUI/Image/ResizingMode``
///
/// See [`SwiftUI.Image/renderingMode(_:)`](https://developer.apple.com/documentation/swiftui/image/resizable(capInsets:resizingMode:)) for more details on this ViewModifier.
///
/// Example:
///
/// ```elixir
/// # stylesheet
/// "example" do
///   resizable(capInsets: EdgeInsets, resizingMode: .tile)
/// end
/// ```
@_documentation(visibility: public)
@ASTDecodable("resizable")
struct _ResizableModifier: ImageModifier {
    let capInsets: EdgeInsets
    let resizingMode: SwiftUI.Image.ResizingMode
    
    init(capInsets: EdgeInsets = EdgeInsets(), resizingMode: SwiftUI.Image.ResizingMode = SwiftUI.Image.ResizingMode.stretch) {
        self.capInsets = capInsets
        self.resizingMode = resizingMode
    }
    
    func apply(to image: SwiftUI.Image, on element: ElementNode) -> SwiftUI.Image {
        image.resizable(
            capInsets: capInsets,
            resizingMode: resizingMode
        )
    }
    
    func body(content: Content) -> some View {
        content
    }
}

/// See [`SwiftUI.Image.ResizingMode`](https://developer.apple.com/documentation/swiftui/Image/ResizingMode) for more details.
///
/// Possible values:
/// - `.tile`
/// - `.stretch`
@_documentation(visibility: public)
extension SwiftUI.Image.ResizingMode: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember([
            "tile": .tile,
            "stretch": .stretch,
        ])
    }
}
