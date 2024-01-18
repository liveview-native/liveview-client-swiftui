//
//  ImagePaint+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 1/17/24.
//

import SwiftUI
import LiveViewNativeStylesheet

extension ImagePaint: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        _ImagePaint.parser(in: context).map(\.value)
    }
    
    @ParseableExpression
    struct _ImagePaint {
        static let name = "ImagePaint"
        
        let value: ImagePaint
        
        init(image: Image, sourceRect: CGRect = .init(x: 0, y: 0, width: 1, height: 1), scale: CGFloat = 1) {
            self.value = .init(image: image, sourceRect: sourceRect, scale: scale)
        }
    }
}

extension Image: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        _Image.parser(in: context).map(\.value)
    }
    
    @ParseableExpression
    struct _Image {
        static let name = "Image"
        
        let value: SwiftUI.Image
        
        init(_ name: String) {
            self.value = .init(name)
        }
        
        init(systemName: String) {
            self.value = .init(systemName: systemName)
        }
        
        init(systemName: String, variableValue: Double?) {
            self.value = .init(systemName: systemName, variableValue: variableValue)
        }
    }
}
