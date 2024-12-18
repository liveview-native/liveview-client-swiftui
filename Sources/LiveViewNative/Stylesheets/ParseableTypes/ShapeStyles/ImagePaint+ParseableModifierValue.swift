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
    
    @ASTDecodable("ImagePaint")
    struct _ImagePaint {
        let value: ImagePaint
        
        init(image: Image, sourceRect: CGRect = .init(x: 0, y: 0, width: 1, height: 1), scale: CGFloat = 1) {
            self.value = .init(image: image, sourceRect: sourceRect, scale: scale)
        }
    }
}

/// See [`SwiftUI.Image`](https://developer.apple.com/documentation/swiftui/Image) for more details.
///
/// Get an image by `name` from the asset catalog, or reference an SF Symbol by its `systemName`.
///
/// ```swift
/// Image("MyImage")
/// Image(systemName: "circle.fill")
/// Image(systemName: "chart.bar.fill", variableValue: 0.6)
/// ```
@_documentation(visibility: public)
extension Image: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        _Image.parser(in: context).map(\.value)
    }
    
    @ASTDecodable("Image")
    struct _Image {
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
