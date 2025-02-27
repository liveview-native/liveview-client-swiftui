//
//  CoreText.swift
//  LiveViewNative
//
//  Created by Carson Katri on 1/30/25.
//

import CoreText
import LiveViewNativeStylesheet

extension CoreText.CTFont {
    enum Resolvable: StylesheetResolvable, @preconcurrency Decodable {
        init(from decoder: any Decoder) throws {
            fatalError("CTFont is not available")
        }
        
        @MainActor
        func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> CoreText.CTFont {
            fatalError("CTFont is not available")
        }
    }
}
