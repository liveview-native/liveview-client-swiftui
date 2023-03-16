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
///     <Section:header>Group #1</Section:header>
///     <Section:content>Item #1</Section:content>
///     <Section:footer>The first group ends here</Section:footer>
/// </Section>
/// <Section>
///     <Section:header>Group #2</Section:header>
///     <Section:content>Item #1</Section:content>
///     <Section:footer>The second group ends here</Section:footer>
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
struct Section<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    private let context: LiveContext<R>
    
    /// Enables this section to be collapsed in sidebar lists on macOS.
    @Attribute("collapsible") private var collapsible: Bool
    
    init(element: ElementNode, context: LiveContext<R>) {
        self.context = context
    }
    
    public var body: some View {
        SwiftUI.Section {
            context.buildChildren(of: element, withTagName: "content", namespace: "section", includeDefaultSlot: true)
        } header: {
            context.buildChildren(of: element, withTagName: "header", namespace: "section")
        } footer: {
            context.buildChildren(of: element, withTagName: "footer", namespace: "section")
        }
        #if os(macOS)
            .collapsible(collapsible)
        #endif
    }
}
