//
//  MonospacedModifier.swift
//
//
//  Created by Carson Katri on 2/21/24.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.View/monospaced(_:)`](https://developer.apple.com/documentation/swiftui/view/monospaced(_:)) for more details on this ViewModifier.
///
/// ### monospaced(_:)
/// - `isActive`: `attr("...")` or ``Swift/Bool``
/// 
/// See [`SwiftUI.View/monospaced(_:)`](https://developer.apple.com/documentation/swiftui/view/monospaced(_:)) for more details on this ViewModifier.
///
/// Example:
///
/// ```elixir
/// # stylesheet
/// "example" do
///   monospaced(attr("isActive"))
/// end
/// ```
///
/// ```heex
/// <%!-- template --%>
/// <Element class="example" isActive={@isActive} />
/// ```
@_documentation(visibility: public)
@ParseableExpression
struct _MonospacedModifier<R: RootRegistry>: TextModifier {
    static var name: String { "monospaced" }

    let isActive: AttributeReference<Bool>

    @ObservedElement private var element
    @LiveContext<R> private var context

    init(_ isActive: AttributeReference<Bool> = .init(storage: .constant(true))) {
        self.isActive = isActive
    }
    

    func body(content: Content) -> some View {
        content.monospaced(isActive.resolve(on: element, in: context))
    }
    
    func apply(to text: SwiftUI.Text, on element: ElementNode) -> SwiftUI.Text {
        if #available(iOS 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *) {
            return text.monospaced(isActive.resolve(on: element))
        } else {
            return text
        }
    }
}
