//
//  LabelStyleModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 4/6/2023.
//

import SwiftUI

/// <#Documentation#>
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct LabelStyleModifier<R: RootRegistry>: ViewModifier, Decodable {
    /// <#Documentation#>
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let style: String
    
    @ObservedElement private var element

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.style = try container.decode(String.self, forKey: .style)
    }

    func body(content: Content) -> some View {
        switch style {
        case "automatic":
            content.labelStyle(.automatic)
        case "icon_only":
            content.labelStyle(.iconOnly)
        case "title_only":
            content.labelStyle(.titleOnly)
        case "title_and_icon":
            content.labelStyle(.titleAndIcon)
        case let custom:
            content
                .labelStyle(CustomLabelStyle<R>(id: custom, element: element))
        }
    }

    enum CodingKeys: String, CodingKey {
        case style
    }
}

struct CustomLabelStyle<R: RootRegistry>: LabelStyle {
    let id: String
    let element: ElementNode
    @LiveContext<R> private var context
    
    struct Title: View {
        @Environment(\.labelStyleConfiguration) private var configuration
        
        var body: some View {
            configuration?.title
        }
    }
    
    struct Icon: View {
        @Environment(\.labelStyleConfiguration) private var configuration
        
        var body: some View {
            configuration?.icon
        }
    }
    
    func makeBody(configuration: Configuration) -> some View {
        context.buildChildren(of: element, withTagName: id, namespace: "label_style", includeDefaultSlot: false)
            .tokenElements([
                "title": { AnyView(CustomLabelStyle<R>.Title()) },
                "icon": { AnyView(CustomLabelStyle<R>.Icon()) },
            ])
            .environment(\.labelStyleConfiguration, configuration)
    }
}

extension EnvironmentValues {
    private enum LabelStyleConfigurationKey: EnvironmentKey {
        static let defaultValue: CustomLabelStyle.Configuration? = nil
    }
    
    var labelStyleConfiguration: CustomLabelStyle.Configuration? {
        get { self[LabelStyleConfigurationKey.self] }
        set { self[LabelStyleConfigurationKey.self] = newValue }
    }
}
