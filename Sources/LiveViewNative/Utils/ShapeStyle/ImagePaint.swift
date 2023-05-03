//
//  ImagePaint.swift
//  
//
//  Created by Carson Katri on 4/25/23.
//

import SwiftUI

/// A shape style that repeats an image.
///
/// To create this shape style, create a map or keyword list with the `image` key set to a key name.
///
/// ```elixir
/// [image: {:system, "basketball.fill"}]
/// [image: {:name, "MyAssetImage"}]
/// ```
///
/// Set the `source_rect` and `scale` to customize the image presentation.
///
/// ```elixir
/// [image: "basketball.fill", source_rect: [x: 0, y: 0, width: 0.5, height: 0.5], scale: 2]
/// ```
///
/// See ``LiveViewNative/SwiftUI/UnitPoint`` for more details on creating the start/end points.
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
extension ImagePaint: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let image: SwiftUI.Image
        if let name = try container.decode(String?.self, forKey: .image) {
            image = .init(name)
        } else {
            image = .init(systemName: try container.decode(String.self, forKey: .systemImage))
        }

        self.init(
            image: image,
            sourceRect: try container.decode(CGRect.self, forKey: .sourceRect),
            scale: try container.decode(CGFloat.self, forKey: .scale)
        )
    }

    enum CodingKeys: String, CodingKey {
        case image
        case systemImage
        case sourceRect
        case scale
    }
}
