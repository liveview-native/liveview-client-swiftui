//
//  PinnedScrollableViews.swift
//  
//
//  Created by Carson Katri on 2/16/23.
//

import SwiftUI
import LiveViewNativeCore

/// Configuration used to pin section headers/footers in lazy containers.
///
/// Possible values:
/// * `section-headers`
/// * `section-footers`
/// * `all`
///
/// In this example, the current section header will always be visible on the leading edge of the screen, up until the next section is scrolled past the left edge.
///
/// ```html
/// <ScrollView axes="horizontal">
///     <LazyHGrid
///         rows={...}
///         pinned-views="section-headers"
///     >
///         <Section>
///             <Section:header>1-50</Section:header>
///             <Section:content>
///                 <%= for i <- 1..50 do %>
///                     <Text id={i |> Integer.to_string}><%= i %></Text>
///                 <% end %>
///             </Section:content>
///         </Section>
///         <Section>
///             <Section:header>51-100</Section:header>
///             <Section:content>
///                 <%= for i <- 51..100 do %>
///                     <Text id={i |> Integer.to_string}><%= i %></Text>
///                 <% end %>
///             </Section:content>
///         </Section>
///     </LazyHGrid>
/// </ScrollView>
/// ```
extension PinnedScrollableViews: Decodable, AttributeDecodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        self = Self(string: string)
    }
    
    init(string: String) {
        switch string {
        case "section-headers":
            self = .sectionHeaders
        case "section-footers":
            self = .sectionFooters
        case "all":
            self = [.sectionHeaders, .sectionFooters]
        default:
            self = .init()
        }
    }
    
    public init(from attribute: LiveViewNativeCore.Attribute?) throws {
        guard let value = attribute?.value else { throw AttributeDecodingError.missingAttribute(Self.self) }
        self.init(string: value)
    }
}
