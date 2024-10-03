//
//  AnyNavigationTransition.swift
//  
//
//  Created by Carson Katri on 6/18/24.
//

import SwiftUI
import LiveViewNativeStylesheet

@available(iOS 18.0, watchOS 11.0, tvOS 18.0, macOS 15.0, visionOS 2.0, *)
enum AnyNavigationTransition: ParseableModifierValue {
    case automatic
    case zoom(Zoom)
    
    func resolve(
        on element: ElementNode,
        in context: LiveContext<some RootRegistry>,
        namespaces: [String:Namespace.ID]
    ) -> any NavigationTransition {
        switch self {
        case .automatic:
            .automatic
        case .zoom(let zoom):
            .zoom(
                sourceID: zoom.sourceID.resolve(on: element, in: context),
                in: namespaces[zoom.namespace.resolve(on: element, in: context)]!
            )
        }
    }
    
    static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
                ConstantAtomLiteral("automatic").map({ Self.automatic })
                Zoom.parser(in: context).map(Self.zoom)
            }
        }
    }
    
    @ParseableExpression
    struct Zoom: ParseableModifierValue {
        static let name = "zoom"
        
        let sourceID: AttributeReference<String>
        let namespace: AttributeReference<String>
        
        init(sourceID: AttributeReference<String>, in namespace: AttributeReference<String>) {
            self.sourceID = sourceID
            self.namespace = namespace
        }
    }
}
