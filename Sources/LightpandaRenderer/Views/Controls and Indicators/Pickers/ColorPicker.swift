//
//  ColorPicker.swift
//
//
//  Created by Carson Katri on 2/14/23.
//

import SwiftUI
import LightpandaClient

/// Presents a system color picker when tapped.
///
/// The color is stored as a hex string (e.g., "#FF5733" or "#FF5733FF" with alpha).
///
/// ```html
/// <ColorPicker selection="#FF5733" supportsOpacity>
///     Favorite Color
/// </ColorPicker>
/// ```
///
/// ## Attributes
/// * ``selection``
/// * ``supportsOpacity``
@_documentation(visibility: public)
struct ColorPicker<Library: ElementLibrary>: View {
    let node: Node
    
    @Environment(LightpandaRuntime.self) private var lightpanda
    
    @State private var color: CGColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 1)
    
    /// Enables the selection of transparent colors.
    @_documentation(visibility: public)
    private var supportsOpacity: Bool {
        node.attributeBoolean(for: "supportsOpacity")
    }
    
    /// The initial color value as a hex string.
    @_documentation(visibility: public)
    private var initialSelection: String? {
        node.attributeValue(for: "selection")
    }
    
    public var body: some View {
        #if os(iOS) || os(macOS)
        SwiftUI.ColorPicker(
            selection: $color,
            supportsOpacity: supportsOpacity
        ) {
            node.children(library: Library.self)
        }
        .onAppear {
            if let hex = initialSelection {
                color = Self.cgColor(from: hex)
            }
        }
        .onChange(of: color) { _, newValue in
            Task {
                let hexString = Self.hexString(from: newValue, includeAlpha: supportsOpacity)
                try await self.node.callFunction(
                    runtime: lightpanda,
                    function: #"""
                    function() {
                        this.value = "\#(hexString)";
                        this.dispatchEvent(new Event("input", { bubbles: true }));
                        this.dispatchEvent(new Event("change", { bubbles: true }));
                    }
                    """#
                )
            }
        }
        .task {
            let id = UUID().uuidString
            _ = try? await lightpanda.cdp.addBinding(name: id) { call in
                Task { @MainActor in
                    color = Self.cgColor(from: call.payload)
                }
            }
            
            let initialHex = initialSelection ?? "#000000"
            try? await self.node.callFunction(runtime: lightpanda, function: #"""
            function() {
                let internalValue = "\#(initialHex)";
                Object.defineProperty(this, "value", {
                    get() { return internalValue; },
                    set(newValue) {
                        internalValue = newValue;
                        globalThis["\#(id)"](newValue);
                    },
                    configurable: true
                });
            }
            """#)
        }
        #endif
    }
    
    /// Converts a hex string to CGColor.
    private static func cgColor(from hex: String) -> CGColor {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if hexString.hasPrefix("#") {
            hexString.removeFirst()
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)
        
        let r, g, b, a: CGFloat
        switch hexString.count {
        case 6: // RGB
            r = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgbValue & 0x0000FF) / 255.0
            a = 1.0
        case 8: // RGBA
            r = CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgbValue & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgbValue & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgbValue & 0x000000FF) / 255.0
        default:
            r = 0; g = 0; b = 0; a = 1
        }
        
        return CGColor(srgbRed: r, green: g, blue: b, alpha: a)
    }
    
    /// Converts a CGColor to hex string.
    private static func hexString(from color: CGColor, includeAlpha: Bool) -> String {
        guard let components = color.converted(to: CGColorSpaceCreateDeviceRGB(), intent: .defaultIntent, options: nil)?.components,
              components.count >= 3 else {
            return "#000000"
        }
        
        let r = Int(components[0] * 255)
        let g = Int(components[1] * 255)
        let b = Int(components[2] * 255)
        
        if includeAlpha && components.count >= 4 {
            let a = Int(components[3] * 255)
            return String(format: "#%02X%02X%02X%02X", r, g, b, a)
        } else {
            return String(format: "#%02X%02X%02X", r, g, b)
        }
    }
}
