//
//  OrnamentAttachmentAnchor+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 5/1/24.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.OrnamentAttachmentAnchor`](https://developer.apple.com/documentation/swiftui/OrnamentAttachmentAnchor) for more details.
///
/// Use `.scene(_:)` with a ``SwiftUI/UnitPoint`` to create an attachment anchor.
///
/// ```swift
/// .scene(.leading)
/// .scene(.bottomTrailing)
/// ```
@_documentation(visibility: public)
@_documentation(visibility: public)
extension OrnamentAttachmentAnchor: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            _Scene.parser(in: context).map(\.value)
        }
    }
    
    @ParseableExpression
    struct _Scene {
        static let name = "scene"
        
        let value: OrnamentAttachmentAnchor
        
        init(_ anchor: UnitPoint) {
            self.value = .scene(anchor)
        }
    }
}
