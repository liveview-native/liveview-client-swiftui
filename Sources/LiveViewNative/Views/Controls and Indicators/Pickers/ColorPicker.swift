//
//  ColorPicker.swift
//
//
//  Created by Carson Katri on 2/14/23.
//

#if os(iOS) || os(macOS)
import SwiftUI

struct ColorPicker<R: CustomRegistry>: View {
    @ObservedElement private var element: ElementNode
    let context: LiveContext<R>
    
    @LiveBinding(attribute: "selection") private var selection: CodableColor = .init(r: 0, g: 0, b: 0, a: 1)
    
    struct CodableColor: Codable {
        var r: CGFloat
        var g: CGFloat
        var b: CGFloat
        var a: CGFloat?
        
        var cgColor: CGColor {
            get {
                .init(red: r, green: g, blue: b, alpha: a ?? 1)
            }
            set {
                guard let components = newValue.components else { return }
                r = components[0]
                g = components[1]
                b = components[2]
                if newValue.numberOfComponents >= 4 {
                    a = components[3]
                } else {
                    a = nil
                }
            }
        }
    }
    
    init(element: ElementNode, context: LiveContext<R>) {
        self.context = context
    }
    
    public var body: some View {
        SwiftUI.ColorPicker(
            selection: $selection.cgColor,
            supportsOpacity: element.attributeBoolean(for: "supports-opacity")
        ) {
            label
        }
    }
    
    private var label: some View {
        context.buildChildren(of: element, withTagName: "label", namespace: "color-picker", includeDefaultSlot: true)
    }
}
#endif
