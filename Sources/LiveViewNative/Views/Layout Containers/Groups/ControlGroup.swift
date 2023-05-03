//
//  ControlGroup.swift
//
//
//  Created by Carson Katri on 2/9/23.
//

import SwiftUI

/// Visual grouping of control elements.
///
/// Provide the `content` and `label` children to create a control group.
///
/// ```html
/// <ControlGroup>
///     <Text template={:label}>Edit Actions</Text>
///     <Group template={:content}>
///         <Button phx-click="arrange">Arrange</Button>
///         <Button phx-click="update">Update</Button>
///         <Button phx-click="remove">Remove</Button>
///     </Group>
/// </ControlGroup>
/// ```
///
/// ## Attributes
/// * ``style``
///
/// ## Children
/// * `label` - Describes the content of the control group.
/// * `content` - Controls to be grouped together.
///
/// ## Topics
/// ### Supporting Types
/// - ``ControlGroupStyle``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(iOS 16.0, macOS 13.0, *)
struct ControlGroup<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    @LiveContext<R> private var context
    
    /// The style to use for this control group.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("control-group-style") private var style: ControlGroupStyle = .automatic

    public var body: some View {
        #if os(iOS) || os(macOS)
        SwiftUI.ControlGroup {
            context.buildChildren(of: element, forTemplate: "content", includeDefaultSlot: true)
        } label: {
            context.buildChildren(of: element, forTemplate: "label")
        }
        .applyControlGroupStyle(style)
        #endif
    }
}

#if swift(>=5.8)
@_documentation(visibility: public)
#endif
fileprivate enum ControlGroupStyle: String, AttributeDecodable {
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case automatic
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case navigation
}

fileprivate extension View {
    @ViewBuilder
    @available(iOS 16.0, macOS 13.0, *)
    func applyControlGroupStyle(_ style: ControlGroupStyle) -> some View {
        #if os(iOS) || os(macOS)
        switch style {
        case .automatic:
            self.controlGroupStyle(.automatic)
        case .navigation:
            self.controlGroupStyle(.navigation)
        }
        #endif
    }
}
