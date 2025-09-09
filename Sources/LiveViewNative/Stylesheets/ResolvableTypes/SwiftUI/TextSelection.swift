//
//  TextSelection.swift
//  LiveViewNative
//
//  Created by Carson.Katri on 9/9/25.
//

import SwiftUI
import LiveViewNativeCore

@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
extension TextSelection: @retroactive Codable, AttributeDecodable {
    public init(from decoder: any Decoder) throws {
        fatalError("not supported")
    }
    
    public func encode(to encoder: any Encoder) throws {
        fatalError("not supported")
    }
    
    public init(from attribute: LiveViewNativeCore.Attribute?, on element: ElementNode) throws {
        fatalError()
    }
}
