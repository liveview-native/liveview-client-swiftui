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
/// The platform provides a wide variety of symbol images which are specified with the `system-name` attribute.
/// See [Apple's documentation](https://developer.apple.com/sf-symbols/) for more information.
///
/// The [`symbol-color`](doc:Image/symbolColor) and [`symbol-scale`](doc:Image/symbolScale) attributes may also be provided.
/// ```html
/// <Image system-name="cloud.sun.rain" symbol-color="#ff0000" symbol-scale="large" />
/// ```
/// ### Asset Catalog
/// Specify the `name` attribute to use a named image from the app's asset catalog.
/// ```html
/// <Image name="MyCustomImage" />
/// ```
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct Image<R: RootRegistry>: View {
    @ObservedElement private var element
    @LiveContext<R> private var context
    
    ///
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("system-name") private var systemName: String?
    ///
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("variable-value") private var variableValue: Double?
    
    ///
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("name") private var name: String?
    
    @Attribute("modifiers") private var modifiers: ImageModifierStack?
    
    init() {}
    
    init(element: ElementNode) {
        self._element = .init(element: element)
        self._systemName = .init("system-name", element: element)
        self._variableValue = .init("variable-value", element: element)
        self._name = .init("name", element: element)
        self._modifiers = .init("modifiers", element: element)
    }
    
    public var body: SwiftUI.Image? {
        if let image {
            var result = image
            for modifier in modifiers?.stack ?? [] {
                result = modifier.apply(to: result)
            }
            return result
        } else {
            return nil
        }
    }
    
    private var image: SwiftUI.Image? {
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
    }
    
    var label: SwiftUI.Text? {
        if let labelNode = element.children().first {
            switch labelNode.data {
            case let .element(element):
                return Text<R>(element: ElementNode(node: labelNode, data: element)).body
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

extension Image {
    enum Mode {
        case symbol(String)
        case asset(String)
    }
}
