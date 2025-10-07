//
//  ContentUnavailableView.swift
//  LightpandaRenderer
//
//  Created by Carson Katri on 11/12/24.
//

import SwiftUI
import LightpandaClient

/// An interface that indicates content is missing or unavailable.
///
/// ```html
/// <ContentUnavailableView>
///     <Label systemImage="tray.fill">No Mail</Label>
///
///     <Text template="description">
///         New mails you receive will appear here.
///     </Text>
///
///     <Group template="actions">
///         <Button phx-click="refresh">Check Again</Button>
///     </Group>
/// </ContentUnavailableView>
/// ```
///
/// You can also create a default `search` view:
///
/// ```html
/// <ContentUnavailableView search />
/// ```
///
/// Optionally `search` to the search query string:
///
/// ```html
/// <ContentUnavailableView search={@query} />
/// ```
///
/// ## Attributes
/// * ``search``
/// * ``image``
/// * ``systemImage``
/// * ``description``
///
/// ## Children
/// * `label` - Describes the current value.
/// * `description` - Describes the current value.
/// * `actions` - Describes the current value.
@_documentation(visibility: public)
struct ContentUnavailableView<Library: ElementLibrary>: View {
    let node: Node
    
    /// The search query string.
    @_documentation(visibility: public)
    private var search: String? {
        node.attributeValue(for: "search")
    }
    
    /// An image to use for the label.
    @_documentation(visibility: public)
    private var image: String? {
        node.attributeValue(for: "image")
    }
    
    /// A system image to use for the label.
    @_documentation(visibility: public)
    private var systemImage: String? {
        node.attributeValue(for: "systemImage")
    }
    
    /// A description of the unavailable content.
    @_documentation(visibility: public)
    private var description: String? {
        node.attributeValue(for: "description")
    }
    
    public var body: some View {
        if let search {
            if search.isEmpty {
                SwiftUI.ContentUnavailableView.search
            } else {
                SwiftUI.ContentUnavailableView.search(text: search)
            }
        } else {
            SwiftUI.ContentUnavailableView {
                if let image {
                    SwiftUI.Label {
                        node.children(in: "label", default: true, library: Library.self)
                    } icon: {
                        SwiftUI.Image(image)
                    }
                } else if let systemImage {
                    SwiftUI.Label {
                        node.children(in: "label", default: true, library: Library.self)
                    } icon: {
                        SwiftUI.Image(systemName: systemImage)
                    }
                } else {
                    node.children(in: "label", default: true, library: Library.self)
                }
            } description: {
                if let description {
                    SwiftUI.Text(description)
                } else {
                    node.children(in: "description", library: Library.self)
                }
            } actions: {
                node.children(in: "actions", library: Library.self)
            }
        }
    }
}
