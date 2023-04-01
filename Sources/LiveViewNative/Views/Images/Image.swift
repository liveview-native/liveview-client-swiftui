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
struct Image: View {
    /// When enabled, resizes the Image to fill all available space
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("resizable") private var resizable: Bool
    @ObservedElement private var observedElement: ElementNode
    private let overrideElement: ElementNode?
    private var element: ElementNode {
        overrideElement ?? observedElement
    }
    
    init(overrideElement: ElementNode? = nil) {
        self.overrideElement = overrideElement
    }
    
    public var body: some View {
        image
            // todo: this probably only works for symbols
            .resizableIfPresent(resizable: resizable)
            .scaledIfPresent(scale: symbolScale)
            .foregroundColorIfPresent(color: symbolColor)
    }
    
    var image: SwiftUI.Image {
        switch mode {
        case .symbol(let name):
            return SwiftUI.Image(systemName: name)
        case .asset(let name):
            return SwiftUI.Image(name)
        }
    }
    
    private var mode: Mode {
        if let systemName = element.attributeValue(for: "system-name") {
            return .symbol(systemName)
        } else if let name = element.attributeValue(for: "name") {
            return .asset(name)
        } else {
            preconditionFailure("<image> must have system-name or name")
        }
    }
    
    /// The foreground color of the symbol.
    ///
    /// If no color is provided, the symbol will use a color appropriate for the environment.
    ///
    /// See ``LiveViewNative/SwiftUI/Color/init(fromNamedOrCSSHex:)``.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private var symbolColor: SwiftUI.Color? {
        if let attr = element.attributeValue(for: "symbol-color") {
            return SwiftUI.Color(fromNamedOrCSSHex: attr)
        } else {
            return nil
        }
    }
    
    /// The display scale of the symbol.
    ///
    /// Possible values:
    /// - `small`
    /// - `medium`
    /// - `large`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private var symbolScale: SwiftUI.Image.Scale? {
        switch element.attributeValue(for: "symbol-scale") {
        case nil:
            return nil
        case "small":
            return .small
        case "medium":
            return .medium
        case "large":
            return .large
        case .some(let attr):
            fatalError("invalid value '\(attr)' for symbol-scale")
        }
    }
}

extension Image {
    enum Mode {
        case symbol(String)
        case asset(String)
    }
}

fileprivate extension SwiftUI.Image {
    func resizableIfPresent(resizable: Bool) -> SwiftUI.Image {
        if resizable {
            return self.resizable()
        } else {
            return self
        }
    }

    @ViewBuilder
    func scaledIfPresent(scale: SwiftUI.Image.Scale?) -> some View {
        if let scale = scale {
            self.imageScale(scale)
        } else {
            self
        }
    }
}

fileprivate extension View {
    @ViewBuilder
    func foregroundColorIfPresent(color: SwiftUI.Color?) -> some View {
        if let color = color {
            self.foregroundColor(color)
        } else {
            self
        }
    }
}
