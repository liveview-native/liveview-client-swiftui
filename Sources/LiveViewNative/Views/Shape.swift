//
//  Shape.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI

struct Shape<S: SwiftUI.Shape>: View {
    @ObservedElement private var element: ElementNode
    private let shape: S
    
    init(element: ElementNode, context: LiveContext<some CustomRegistry>, shape: S) {
        self.shape = shape
    }
    
    var body: some View {
        if let s = element.attributeValue(for: "fill-color"), let color = Color(fromNamedOrCSSHex: s) {
            shape.fill(color)
        } else if let s = element.attributeValue(for: "stroke-color"), let color = Color(fromNamedOrCSSHex: s) {
            shape.stroke(color)
        } else {
            shape
        }
    }
}

extension RoundedRectangle {
    init(from element: ElementNode) {
        let radius: Double
        if let s = element.attributeValue(for: "corner-radius"), let d = Double(s) {
            radius = d
        } else {
            radius = 5
        }
        self.init(cornerRadius: radius)
    }
}
