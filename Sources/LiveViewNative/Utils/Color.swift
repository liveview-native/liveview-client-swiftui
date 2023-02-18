//
//  Color.swift
// LiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI

private let colorRegex = try! NSRegularExpression(pattern: "^#[0-9a-f]{6}$", options: .caseInsensitive)

extension Color: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let createWith = try container.decode(String?.self, forKey: .createWith)
        var color: Color?

        switch createWith {
            case "string":
                if let string = try container.decode(String?.self, forKey: .string) {
                    color = Color(fromNamedOrCSSHex: string)!
                }

            case "rgb_color_space":
                color = try Color(fromEncodedRGBColorSpace: decoder)

            default:
                throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "expected valid value for createWith"))
        }
        self = color!
    }

    public init?(fromEncodedRGBColorSpace decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let colorSpace: Color.RGBColorSpace = .sRGB
        var opacity: Double = 1
        var white: Double = 0
        var red: Double = 0
        var green: Double = 0
        var blue: Double = 0

        if let number = try container.decode(Double?.self, forKey: .opacity) {
            opacity = number
        }
        if let number = try container.decode(Double?.self, forKey: .white) {
            white = number

            self = Color(colorSpace, white: white, opacity: opacity)
        } else {
            if let number = try container.decode(Double?.self, forKey: .red) {
                red = number
            }
            if let number = try container.decode(Double?.self, forKey: .green) {
                green = number
            }
            if let number = try container.decode(Double?.self, forKey: .blue) {
                blue = number
            }
            self = Color(colorSpace, red: red, green: green, blue: blue, opacity: opacity)
        }
    }

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
