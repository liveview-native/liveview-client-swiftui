//
//  TabViewCustomization+Codable.swift
//  LiveViewNative
//
//  Created by Carson Katri on 2/18/25.
//

#if os(iOS) || os(macOS) || os(visionOS)
import SwiftUI
import LiveViewNativeStylesheet
import LiveViewNativeCore

@available(iOS 18.0, macOS 15.0, visionOS 2.0, *)
extension TabViewCustomization: AttributeDecodable {
    public init(from attribute: Attribute?, on element: ElementNode) throws {
        self.init()
    }
}
#endif
