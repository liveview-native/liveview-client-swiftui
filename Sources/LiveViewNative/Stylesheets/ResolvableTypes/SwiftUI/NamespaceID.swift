//
//  NamespaceID.swift
//  LiveViewNative
//
//  Created by Carson.Katri on 2/4/25.
//

import SwiftUI
import LiveViewNativeStylesheet

extension Namespace.ID {
    struct Resolvable: StylesheetResolvable, @preconcurrency Decodable {
        let value: AttributeReference<String>
        
        init(from decoder: any Decoder) throws {
            self.value = try decoder.singleValueContainer().decode(AttributeReference<String>.self)
        }
        
        func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Namespace.ID {
            return context.namespaces[value.resolve(on: element, in: context)]!
        }
    }
}
