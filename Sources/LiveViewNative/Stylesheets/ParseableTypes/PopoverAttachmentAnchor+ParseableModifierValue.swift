//
//  PopoverAttachmentAnchor+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 11/22/23.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.PopoverAttachmentAnchor`](https://developer.apple.com/documentation/swiftui/PopoverAttachmentAnchor) for more details.
///
/// ### Point Attachment
/// Use a ``SwiftUI/UnitPoint`` to specify an anchor point relative to the element.
///
/// ```swift
/// .point(.topLeading)
/// .point(.bottomTrailing)
/// ```
///
/// ### Rect Attachment
/// Use a ``SwiftUI/Anchor/Source`` to specify an anchor point relative to a frame.
///
/// ```swift
/// .rect(.bounds)
/// .rect(.rect(CGRect(x: 0, y: 0, width: 50, height: 50)))
/// ```
@_documentation(visibility: public)
extension PopoverAttachmentAnchor: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
                Rect.parser(in: context).map({ Self.rect($0.source) })
                Point.parser(in: context).map({ Self.point($0.point) })
            }
        }
    }
    
    @ASTDecodable("rect")
    struct Rect {
        let source: Anchor<CGRect>.Source
        
        init(_ source: Anchor<CGRect>.Source) {
            self.source = source
        }
    }
    
    @ASTDecodable("point")
    struct Point {
        let point: UnitPoint
        
        init(_ point: UnitPoint) {
            self.point = point
        }
    }
}
