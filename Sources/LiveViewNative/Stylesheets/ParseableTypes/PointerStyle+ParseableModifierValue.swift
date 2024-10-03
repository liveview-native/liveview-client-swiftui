//
//  PointerStyle+ParseableModifierValue.swift
//  
//
//  Created by Carson.Katri on 6/19/24.
//

import SwiftUI
import LiveViewNativeStylesheet

#if os(macOS) || os(visionOS)
@available(macOS 15, visionOS 2, *)
extension PointerStyle: @retroactive ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
                #if os(macOS)
                ColumnResize.parser(in: context).map(\.value)
                FrameResize.parser(in: context).map(\.value)
                Image.parser(in: context).map(\.value)
                RowResize.parser(in: context).map(\.value)
                #endif
                
                #if os(visionOS)
                Shape.parser(in: context).map(\.value)
                #endif
                
                ConstantAtomLiteral("default").map({ Self.`default` })
                
                #if os(macOS)
                ConstantAtomLiteral("columnResize").map({ Self.columnResize })
                ConstantAtomLiteral("grabActive").map({ Self.grabActive })
                ConstantAtomLiteral("grabIdle").map({ Self.grabIdle })
                ConstantAtomLiteral("horizontalText").map({ Self.horizontalText })
                ConstantAtomLiteral("link").map({ Self.link })
                ConstantAtomLiteral("rectSelection").map({ Self.rectSelection })
                ConstantAtomLiteral("rowResize").map({ Self.rowResize })
                ConstantAtomLiteral("verticalText").map({ Self.verticalText })
                ConstantAtomLiteral("zoomIn").map({ Self.zoomIn })
                ConstantAtomLiteral("zoomOut").map({ Self.zoomOut })
                #endif
            }
        }
    }
    
    #if os(macOS)
    @ParseableExpression
    struct ColumnResize {
        static let name = "columnResize"
        
        let value: PointerStyle
        
        init(directions: HorizontalDirection.Set) {
            self.value = .columnResize(directions: directions)
        }
    }
    
    @ParseableExpression
    struct FrameResize {
        static let name = "frameResize"
        
        let value: PointerStyle
        
        init(
            position: FrameResizePosition,
            directions: FrameResizeDirection.Set = .all
        ) {
            self.value = .frameResize(position: position, directions: directions)
        }
    }
    
    @ParseableExpression
    struct Image {
        static let name = "image"
        
        let value: PointerStyle
        
        init(
            _ image: SwiftUI.Image,
            hotSpot: UnitPoint
        ) {
            self.value = .image(image, hotSpot: hotSpot)
        }
    }
    
    @ParseableExpression
    struct RowResize {
        static let name = "rowResize"
        
        let value: PointerStyle
        
        init(directions: VerticalDirection.Set) {
            self.value = .rowResize(directions: directions)
        }
    }
    #endif
    
    #if os(visionOS)
    @ParseableExpression
    struct Shape {
        static let name = "shape"
        
        let value: PointerStyle
        
        init(
            _ shape: AnyShape,
            eoFill: Bool = false,
            size: CGSize
        ) {
            self.value = .shape(shape, eoFill: eoFill, size: size)
        }
    }
    #endif
}
#endif

@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
extension HorizontalDirection.Set: @retroactive ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            Array<Self.Element>.parser(in: context).map({ Self.init($0) })
            ImplicitStaticMember([
                "all": Self.all,
                "leading": Self.leading,
                "trailing": Self.trailing,
            ])
        }
    }
}

@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
extension VerticalDirection.Set: @retroactive ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            Array<Self.Element>.parser(in: context).map({ Self.init($0) })
            ImplicitStaticMember([
                "all": Self.all,
                "up": Self.up,
                "down": Self.down,
            ])
        }
    }
}

#if os(macOS)
@available(macOS 15.0, *)
extension FrameResizeDirection.Set: @retroactive ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            Array<Self.Element>.parser(in: context).map({ Self.init($0) })
            ImplicitStaticMember([
                "all": Self.all,
                "inward": Self.inward,
                "outward": Self.outward,
            ])
        }
    }
}
#endif
