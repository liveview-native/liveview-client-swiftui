//
//  NavigationViewStyle.swift
//  LiveViewNative
//
//  Created by Carson Katri on 3/6/25.
//

import SwiftUI
import LiveViewNativeStylesheet
import LiveViewNativeCore

struct StylesheetResolvableNavigationViewStyle: StylesheetResolvable, @preconcurrency Decodable, @preconcurrency AttributeDecodable {
    init(from decoder: any Decoder) throws {
        fatalError("`NavigationViewStyle` is deprecated")
    }
    
    init(from attribute: Attribute?, on element: ElementNode) throws {
        fatalError("`NavigationViewStyle` is deprecated")
    }
    
    func resolve<R>(on element: ElementNode, in context: LiveContext<R>) -> DefaultNavigationViewStyle where R : RootRegistry {
        fatalError("`NavigationViewStyle` is deprecated")
    }
}
