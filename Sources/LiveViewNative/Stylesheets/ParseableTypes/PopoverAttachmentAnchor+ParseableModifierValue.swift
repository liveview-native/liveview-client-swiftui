//
//  PopoverAttachmentAnchor+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 11/22/23.
//

import SwiftUI
import LiveViewNativeStylesheet

extension PopoverAttachmentAnchor: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
                Rect.parser(in: context).map({ Self.rect($0.source) })
                Point.parser(in: context).map({ Self.point($0.point) })
            }
        }
    }
    
    @ParseableExpression
    struct Rect {
        static let name = "rect"
        let source: Anchor<CGRect>.Source
        
        init(_ source: Anchor<CGRect>.Source) {
            self.source = source
        }
    }
    
    @ParseableExpression
    struct Point {
        static let name = "point"
        let point: UnitPoint
        
        init(_ point: UnitPoint) {
            self.point = point
        }
    }
}
