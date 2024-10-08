//
//  NavigationTransitionModifier.swift
//  
//
//  Created by Carson.Katri on 6/18/24.
//

import SwiftUI
import LiveViewNativeStylesheet

// manual implementation
// Requires namespace access.
/// See [`SwiftUI.View/navigationTransition(_:)`](https://developer.apple.com/documentation/swiftui/view/navigationTransition(_:)) for more details on this ViewModifier.
///
/// - Note: This modifier must be applied to the ``SwiftUI/NavigationLink`` element to take effect.
///
/// ### navigationTransition(_:)
/// - `style`: ``AnyNavigationTransition`` (required)
///
/// Create a namespace with the ``NamespaceContext`` element.
///
/// See [`SwiftUI.View/navigationTransition(_:)`](https://developer.apple.com/documentation/swiftui/view/navigationTransition(_:)) for more details on this ViewModifier.
///
/// Example:
///
/// ```html
/// <NavigationLink
///   destination="..."
///   style='navigationTransition(.zoom(sourceID: attr("sourceID"), in: :namespace))'
///   sourceID="target"
/// >
///   <Rectangle
///     id="target"
///     style='matchedTransitionSource(id: attr("id"), in: :namespace)'
///   />
/// </NavigationLink>
/// ```
@_documentation(visibility: public)
@ParseableExpression
struct _NavigationTransitionModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "navigationTransition" }
    
    let style: Any
    
    @ObservedElement private var element
    @LiveContext<R> private var context
    @Environment(\.namespaces) private var namespaces
    
    @available(iOS 18.0, watchOS 11.0, tvOS 18.0, macOS 15.0, visionOS 2.0, *)
    init(_ style: AnyNavigationTransition) {
        self.style = style
    }

    @ViewBuilder
    func body(content: Content) -> some View {
        if #available(iOS 18.0, watchOS 11.0, tvOS 18.0, macOS 15.0, visionOS 2.0, *) {
            content
                .environment(\._anyNavigationTransition, _AnyNavigationTransition(value: (style as! AnyNavigationTransition).resolve(on: element, in: context, namespaces: namespaces)))
        } else {
            content
        }
    }
}

@available(iOS 18.0, watchOS 11.0, tvOS 18.0, macOS 15.0, visionOS 2.0, *)
struct _AnyNavigationTransition: NavigationTransition {
    let value: any NavigationTransition
    
    func _outputs(for inputs: _NavigationTransitionInputs) -> _NavigationTransitionOutputs {
        value._outputs(for: inputs)
    }
}

extension EnvironmentValues {
    @Entry var _anyNavigationTransition: Any?
}
