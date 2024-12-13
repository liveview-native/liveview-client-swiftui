//
//  Section.swift
//  
//
//  Created by Carson Katri on 2/2/23.
//

import SwiftUI

/// Groups elements in a container.
///
/// Use a section to group together elements in ``List``, ``Picker``, and other container elements.
///
/// ```html
/// <Section>
///     <Text>Item #1</Text>
///     ...
/// </Section>
/// <Section>
///     <Text>Item #1</Text>
///     ...
/// </Section>
/// ```
///
/// Add a `header` and `footer` to customize sections.
///
/// ```html
/// <Section>
///     <Text template={:header}>Group #1</Text>
///     <Text template={:content}>Item #1</Text>
///     <Text template={:footer}>The first group ends here</Text>
/// </Section>
/// <Section>
///     <Text template={:header}>Group #2</Text>
///     <Text template={:content}>Item #1</Text>
///     <Text template={:footer}>The second group ends here</Text>
/// </Section>
/// ```
///
/// On macOS, ``ListStyle/sidebar`` can have collapsible sections. Use the ``isExpanded`` attribute to make a section collapsible.
///
/// ```html
/// <Section isExpanded={@is_expanded} phx-change="expansion_changed">
///     ...
/// </Section>
/// ```
///
/// ## Attributes
/// * ``isExpanded``
///
/// ## Children
/// * `content` - The main body of the section.
/// * `header` - Describes the content of the section.
/// * `footer` - Elements displayed at the end of the section.
@_documentation(visibility: public)
@LiveElement
struct Section<Root: RootRegistry>: View {
    /// Enables this section to be collapsed in sidebar lists.
    @_documentation(visibility: public)
    @ChangeTracked(attribute: .init(name: "isExpanded"))
    private var isExpanded: Bool? = nil
    
    var content: some View {
        let elements = $liveElement.childNodes(in: "content", default: true)
            .map { (node) -> ForEachElement in
                if let element = node.asElement(),
                   let id = element.attributeValue(for: .init(name: "id"))
                {
                    return .keyed(node, id: id)
                } else {
                    return .unkeyed(node)
                }
            }
        return ForEach(elements) { childNode in
            ViewTreeBuilder<Root>.NodeView(node: childNode.node, context: $liveElement.context.storage)
                .trackListItemScrollOffset(id: childNode.id)
        }
    }
    
    var header: some View {
        $liveElement.children(in: "header")
    }
    
    var footer: some View {
        $liveElement.children(in: "footer")
    }
    
    public var body: some View {
        if isExpanded != nil,
           #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, visionOS 1.0, *)
        {
            SwiftUI.Section(isExpanded: Binding {
                isExpanded ?? false
            } set: {
                isExpanded = $0
            }) {
                content
            } header: {
                header
            }
        } else {
            SwiftUI.Section {
                content
            } header: {
                header
            } footer: {
                footer
            }
        }
    }
}
