//
//  Color.swift
// LiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI
import LiveViewNativeCore

struct Color<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    private let context: LiveContext<R>
    
    @Attribute("opacity") private var opacity: Double = 1
    
    @Attribute("name") private var name: String?
    
    @Attribute("red") private var red: Double?
    @Attribute("green") private var green: Double?
    @Attribute("blue") private var blue: Double?
    
    @Attribute("color-space") private var colorSpace: SwiftUI.Color.RGBColorSpace = .sRGB
    
    init(context: LiveContext<R>) {
        self.context = context
    }
    
    var body: some View {
        if let named = name.flatMap(SwiftUI.Color.init(fromNamedOrCSSHex:)) {
            named.opacity(opacity)
        } else if let red,
                  let green,
                  let blue
        {
            SwiftUI.Color(
                colorSpace,
                red: red,
                green: green,
                blue: blue,
                opacity: opacity
            )
        }
    }
}

private let colorRegex = try! NSRegularExpression(pattern: "^#[0-9a-f]{6}$", options: .caseInsensitive)

extension SwiftUI.Color.RGBColorSpace: AttributeDecodable {
    public init(from attribute: LiveViewNativeCore.Attribute?) throws {
        switch attribute?.value {
        case "srgb": self = .sRGB
        case "srgb-linear": self = .sRGBLinear
        case "display-p3": self = .displayP3
        default: throw AttributeDecodingError.missingAttribute(Self.self)
        }
    }
}

// extension Color: Decodable {
//     public init(from decoder: Decoder) throws {
//         let container = try decoder.container(keyedBy: CodingKeys.self)
//         var color: Color = Color(fromNamedOrCSSHex: "#000000")!

//         if let createWith = try container.decode(String?.self, forKey: .createWith) {
//             switch createWith {
//                 case "string":
//                     if let string = try container.decode(String?.self, forKey: .string) {
//                         color = Color(fromNamedOrCSSHex: string)!
//                     }

//                 case "rgb_color_space":
//                     let colorSpace: Color.RGBColorSpace = .sRGB
//                     var opacity: Double = 1
//                     var white: Double = 0
//                     var red: Double = 0
//                     var green: Double = 0
//                     var blue: Double = 0

//                     if let number = try container.decode(Double?.self, forKey: .opacity) {
//                         opacity = number
//                     }
//                     if let number = try container.decode(Double?.self, forKey: .white) {
//                         white = number

//                         color = Color(colorSpace, white: white, opacity: opacity)
//                     } else {
//                         if let number = try container.decode(Double?.self, forKey: .red) {
//                             red = number
//                         }
//                         if let number = try container.decode(Double?.self, forKey: .green) {
//                             green = number
//                         }
//                         if let number = try container.decode(Double?.self, forKey: .blue) {
//                             blue = number
//                         }
//                         color = Color(colorSpace, red: red, green: green, blue: blue, opacity: opacity)
//                     }

//                 default:
//                 // TODO: Fix this
//                 color = Color(fromNamedOrCSSHex: nil)!
//             }
//         }
//         self = color
//     }


extension SwiftUI.Color {
    public init?(fromCSSHex string: String?) {
        guard let string = string else {
            return nil
        }

        if colorRegex.firstMatch(in: string, options: [], range: NSRange(location: 0, length: string.utf16.count)) != nil {
            let r = Int(string[string.index(string.startIndex, offsetBy: 1)..<string.index(string.startIndex, offsetBy: 3)], radix: 16)!
            let g = Int(string[string.index(string.startIndex, offsetBy: 3)..<string.index(string.startIndex, offsetBy: 5)], radix: 16)!
            let b = Int(string[string.index(string.startIndex, offsetBy: 5)..<string.index(string.startIndex, offsetBy: 7)], radix: 16)!
            self.init(red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255)
        } else {
            return nil
        }
    }
    
    public init?(fromNamedOrCSSHex string: String?) {
        switch string {
        case nil:
            return nil
        case "system-black":
            self = .black
        case "system-blue":
            self = .blue
        case "system-brown":
            self = .brown
        case "system-clear":
            self = .clear
        case "system-cyan":
            self = .cyan
        case "system-gray":
            self = .gray
        case "system-green":
            self = .green
        case "system-indigo":
            self = .indigo
        case "system-mint":
            self = .mint
        case "system-orange":
            self = .orange
        case "system-pink":
            self = .pink
        case "system-purple":
            self = .purple
        case "system-red":
            self = .red
        case "system-teal":
            self = .teal
        case "system-white":
            self = .white
        case "system-yellow":
            self = .yellow
        case "system-accent":
            self = .accentColor
        case "system-primary":
            self = .primary
        case "system-secondary":
            self = .secondary
        case let string?:
            if let hexColor = Self(fromCSSHex: string) {
                self = hexColor
            } else {
                self = .init(string)
            }
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case blue
        case brightness
        case createWith = "create_with"
        case green
        case hue
        case opacity
        case red
        case saturation
        case string
        case white
    }
}
