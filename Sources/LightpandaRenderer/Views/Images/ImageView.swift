//
//  Image.swift
//  LightpandaRenderer
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI
import LightpandaClient

/// Displays an image.
///
/// There are two possible sources for images: system-provided images (SF Symbols) or the app's asset catalog.
///
/// ### SF Symbols
/// The platform provides a wide variety of symbol images which are specified with the ``systemName`` attribute.
/// See [Apple's documentation](https://developer.apple.com/sf-symbols/) for more information.
///
/// ### Asset Catalog
/// Specify the `name` attribute to use a named image from the app's asset catalog.
/// ```html
/// <Image name="MyCustomImage" />
/// ```
///
/// ### Variable Value
/// Some symbols and asset images support a value input. Use the ``variableValue`` attribute to set this value.
///
/// ```html
/// <Image systemName="chart.bar.fill" variableValue={0.3} />
/// <Image systemName="chart.bar.fill" variableValue={0.6} />
/// <Image systemName="chart.bar.fill" variableValue={1.0} />
/// ```
///
/// ### Image Labels
/// Text content within the image will be used as the accessibility label.
///
/// ```html
/// <Image name="landscape">
///   Mountain landscape with a lake in the foreground
/// </Image>
/// ```
///
/// ### Modifying Images
/// Use image modifiers to customize the appearance of an image.
///
/// ```elixir
/// "heart" do
///     resizable()
///     symbolRenderingMode(.multicolor)
/// end
/// ```
///
/// ```html
/// <Image systemName="heart.fill" class="heart" />
/// ```
///
/// ## Attributes
/// * ``systemName``
/// * ``name``
/// * ``variableValue``
@_documentation(visibility: public)
enum ImageView<Library: ElementLibrary>: View {
    case node(Node)
    case image(SwiftUI.Image)
    
    /// The name of the system image (SF Symbol) to display.
    ///
    /// See [Apple's documentation](https://developer.apple.com/sf-symbols/) for more information.
    @_documentation(visibility: public)
    private var systemName: String? {
        switch self {
        case let .node(node):
            return node.attributeValue(for: "systemName")
        default:
            return nil
        }
    }
    /// The name of an image in the app's asset catalog.
    @_documentation(visibility: public)
    private var name: String? {
        switch self {
        case let .node(node):
            return node.attributeValue(for: "name")
        default:
            return nil
        }
    }

    /// The value represented by this image, in the range `0.0` to `1.0`.
    @_documentation(visibility: public)
    private var variableValue: Double? {
        switch self {
        case let .node(node):
            return node.attributeValue(for: "variableValue", strategy: .number)
        default:
            return nil
        }
    }

    public var body: SwiftUI.Image? {
        image // TODO: image modifiers
    }

    var image: SwiftUI.Image? {
        switch self {
        case .node:
            if let systemName {
                return SwiftUI.Image(systemName: systemName, variableValue: variableValue)
            } else if let name {
                if let variableValue {
                    if let label {
                        return SwiftUI.Image(name, variableValue: variableValue, label: label)
                    } else {
                        return SwiftUI.Image(name, variableValue: variableValue)
                    }
                } else {
                    if let label {
                        return SwiftUI.Image(name, label: label)
                    } else {
                        return SwiftUI.Image(name)
                    }
                }
            } else {
                return nil
            }
        case let .image(image):
            return image
        }
    }

    var label: SwiftUI.Text? {
        switch self {
        case let .node(node):
            if let labelNode = node.children.first {
                switch labelNode.type {
                case .element:
                    return TextView<Library>(node: labelNode).body
                case .text:
                    return .init(labelNode.value)
                default:
                    return nil
                }
            } else {
                return nil
            }
        case .image:
            return nil
        }
    }
}

extension ImageView {
    enum Mode {
        case symbol(String)
        case asset(String)
    }
}
