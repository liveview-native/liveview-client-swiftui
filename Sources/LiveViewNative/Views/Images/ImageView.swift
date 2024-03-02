//
//  Image.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI

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
@LiveElement
struct ImageView<Root: RootRegistry>: View {
    /// The name of the system image (SF Symbol) to display.
    ///
    /// See [Apple's documentation](https://developer.apple.com/sf-symbols/) for more information.
    @_documentation(visibility: public)
    private var systemName: String?
    /// The name of an image in the app's asset catalog.
    @_documentation(visibility: public)
    private var name: String?

    /// The value represented by this image, in the range `0.0` to `1.0`.
    @_documentation(visibility: public)
    private var variableValue: Double?

    @LiveElementIgnored
    @ClassModifiers<Root> private var modifiers
    let overrideImage: SwiftUI.Image?

    init() {
        self.overrideImage = nil
    }

    init(image: SwiftUI.Image? = nil) {
        self.overrideImage = image
    }

    init(element: ElementNode, overrideStylesheet: Stylesheet<Root>?, overrideImage: SwiftUI.Image? = nil) {
        self._liveElement = .init(element: element)
        self._modifiers = .init(element: element, overrideStylesheet: overrideStylesheet)
        self.overrideImage = overrideImage
    }

    public var body: SwiftUI.Image? {
        image.flatMap({ (image: SwiftUI.Image) -> SwiftUI.Image in
            return modifiers.reduce(image) { result, modifier in
                if case let ._anyImageModifier(imageModifier) = modifier {
                    return imageModifier.apply(to: result, on: $liveElement.element)
                } else {
                    return result
                }
            }
        })
    }

    var image: SwiftUI.Image? {
        if let overrideImage {
            return overrideImage
        } else if let systemName {
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
    }

    var label: SwiftUI.Text? {
        if let labelNode = $liveElement.childNodes.first {
            switch labelNode.data() {
            case let .nodeElement(element):
                return Text<Root>(element: ElementNode(node: labelNode, data: element), overrideStylesheet: _modifiers.overrideStylesheet).body
            case let .leaf(label):
                return .init(label)
            case .root:
                return nil
            }
        } else {
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
