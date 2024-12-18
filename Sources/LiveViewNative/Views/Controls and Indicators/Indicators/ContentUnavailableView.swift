//
//  ContentUnavailableView.swift
//  LiveViewNative
//
//  Created by Carson Katri on 11/12/24.
//

import SwiftUI

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
@LiveElement
struct ContentUnavailableView<Root: RootRegistry>: View {
    /// The search query string.
    @_documentation(visibility: public)
    private var search: String?
    
    /// An image to use for the label.
    @_documentation(visibility: public)
    private var image: String?
    
    /// A system image to use for the label.
    @_documentation(visibility: public)
    private var systemImage: String?
    
    /// A description of the unavailable content.
    @_documentation(visibility: public)
    private var description: String?
    
    public var body: some View {
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
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
                            $liveElement.children(in: "label", default: true)
                        } icon: {
                            SwiftUI.Image(image)
                        }
                    } else if let systemImage {
                        SwiftUI.Label {
                            $liveElement.children(in: "label", default: true)
                        } icon: {
                            SwiftUI.Image(systemName: systemImage)
                        }
                    } else {
                        $liveElement.children(in: "label", default: true)
                    }
                } description: {
                    if let description {
                        SwiftUI.Text(description)
                    } else {
                        $liveElement.children(in: "description")
                    }
                } actions: {
                    $liveElement.children(in: "actions")
                }
            }
        }
    }
}
