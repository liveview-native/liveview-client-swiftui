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
/// On macOS, ``ListStyle/sidebar`` can have collapsible sections. Use the ``collapsible`` attribute to make a section collapsible.
///
/// ```html
/// <Section collapsible>
///     ...
/// </Section>
/// ```
///
/// ## Attributes
/// * ``collapsible``
///
/// ## Children
/// * `content` - The main body of the section.
/// * `header` - Describes the content of the section.
/// * `footer` - Elements displayed at the end of the section.
@_documentation(visibility: public)
@LiveElement
struct Section<Root: RootRegistry>: View {
    /// Enables this section to be collapsed in sidebar lists on macOS.
    @_documentation(visibility: public)
    private var collapsible: Bool = false
    
    @LiveElementIgnored
    @Environment(\.onDeleteAction)
    private var onDeleteAction: ((IndexSet) -> Void)?
    
    public var body: some View {
        SwiftUI.Section {
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
            ForEach(elements) { childNode in
                ViewTreeBuilder<Root>.NodeView(node: childNode.node, context: $liveElement.context.storage)
                    .trackListItemScrollOffset(id: childNode.id)
            }
            .onDelete(perform: onDeleteAction)
        } header: {
            $liveElement.children(in: "header")
        } footer: {
            $liveElement.children(in: "footer")
        }
        #if os(macOS)
            .collapsible(collapsible)
        #endif
        
    }
}
