//
//  Section.swift
//  
//
//  Created by Carson Katri on 2/2/23.
//

import SwiftUI
import LightpandaClient

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
struct Section<Library: ElementLibrary>: View {
    let node: Node
    
    // TODO: events
    /// Enables this section to be collapsed in sidebar lists.
//    @_documentation(visibility: public)
//    @ChangeTracked(attribute: .init(name: "isExpanded"))
//    private var isExpanded: Bool? = nil
    
    var content: some View {
        node.children(library: Library.self)
    }
    
    var header: some View {
        node.children(in: "header", library: Library.self)
    }
    
    var footer: some View {
        node.children(in: "footer", library: Library.self)
    }
    
    public var body: some View {
        SwiftUI.Section {
            content
        } header: {
            header
        } footer: {
            footer
        }
    }
}
