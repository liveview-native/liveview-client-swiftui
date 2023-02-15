//
//  Image.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI

struct Image<R: CustomRegistry>: View {
    @ObservedElement private var observedElement: ElementNode
    private let overrideElement: ElementNode?
    private var element: ElementNode {
        overrideElement ?? observedElement
    }
    
    init(element: ElementNode, context: LiveContext<R>) {
        self.overrideElement = nil
    }
    
    init(overrideElement: ElementNode, context: LiveContext<R>) {
        self.overrideElement = overrideElement
    }
    
    public var body: some View {
        image
            // todo: this probably only works for symbols
            .scaledIfPresent(scale: symbolScale)
            .foregroundColor(symbolColor)
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
    
    private var symbolColor: Color? {
        if let attr = element.attributeValue(for: "symbol-color") {
            return Color(fromNamedOrCSSHex: attr)
        } else {
            return nil
        }
    }
    
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
    @ViewBuilder
    func scaledIfPresent(scale: SwiftUI.Image.Scale?) -> some View {
        if let scale = scale {
            self.imageScale(scale)
        } else {
            self
        }
    }
}
