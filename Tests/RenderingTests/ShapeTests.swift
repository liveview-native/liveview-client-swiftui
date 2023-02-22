//
//  ShapeTests.swift
//  
//
//  Created by Carson Katri on 1/18/23.
//

import XCTest
import SwiftUI
@testable import LiveViewNative

@MainActor
final class ShapeTests: XCTestCase {
    func testRectangle() throws {
        try assertMatch(#"<rectangle />"#) {
            Rectangle()
        }
    }
    
    func testRoundedRectangle() throws {
        try assertMatch(#"<rounded-rectangle corner-radius="5" />"#, size: .init(width: 100, height: 50)) {
            RoundedRectangle(cornerRadius: 5)
        }
        try assertMatch(#"<rounded-rectangle corner-width="5" corner-height="10" />"#, size: .init(width: 100, height: 50)) {
            RoundedRectangle(cornerSize: .init(width: 5, height: 10))
        }
        try assertMatch(#"<rounded-rectangle corner-width="5" corner-radius="15" />"#, size: .init(width: 100, height: 50)) {
            RoundedRectangle(cornerSize: .init(width: 5, height: 15))
        }
        try assertMatch(#"<rounded-rectangle corner-height="5" corner-radius="15" />"#, size: .init(width: 100, height: 50)) {
            RoundedRectangle(cornerSize: .init(width: 15, height: 5))
        }
        try assertMatch(#"<rounded-rectangle corner-radius="10" style="continuous" />"#, size: .init(width: 100, height: 50)) {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
        }
    }
    
    func testCircle() throws {
        try assertMatch(#"<circle />"#) {
            Circle()
        }
    }
    
    func testEllipse() throws {
        try assertMatch(#"<ellipse />"#, size: .init(width: 100, height: 50)) {
            Ellipse()
        }
    }
    
    func testCapsule() throws {
        try assertMatch(#"<capsule />"#, size: .init(width: 100, height: 50)) {
            Capsule()
        }
        try assertMatch(#"<capsule />"#, size: .init(width: 50, height: 100)) {
            Capsule()
        }
        try assertMatch(#"<capsule style="continuous" />"#, size: .init(width: 100, height: 50)) {
            Capsule(style: .continuous)
        }
    }
    
    func testContainerRelativeShape() throws {
        try assertMatch(#"<container-relative-shape />"#) {
            ContainerRelativeShape()
        }
    }
    
    // MARK: Color
    
    func testSystemColor() throws {
        try assertMatch(#"<color name="system-red" />"#, size: .init(width: 50, height: 50)) {
            Color.red
        }
    }
    
    func testRGBColor() throws {
        try assertMatch(#"<color red="1" green="0.5" blue="0.25" />"#, size: .init(width: 50, height: 50)) {
            Color(red: 1, green: 0.5, blue: 0.25)
        }
    }
    
    func testRGBColorSpace() throws {
        try assertMatch(#"<color red="1" green="0.5" blue="0.25" color-space="srgb" />"#, size: .init(width: 50, height: 50)) {
            Color(.sRGB, red: 1, green: 0.5, blue: 0.25)
        }
        try assertMatch(#"<color red="1" green="0.5" blue="0.25" color-space="srgb-linear" />"#, size: .init(width: 50, height: 50)) {
            Color(.sRGBLinear, red: 1, green: 0.5, blue: 0.25)
        }
        try assertMatch(#"<color red="1" green="0.5" blue="0.25" color-space="display-p3" />"#, size: .init(width: 50, height: 50)) {
            Color(.displayP3, red: 1, green: 0.5, blue: 0.25)
        }
    }
    
    func testColorOpacity() throws {
        try assertMatch(#"<color name="system-red" opacity="0.5" />"#, size: .init(width: 50, height: 50)) {
            Color.red.opacity(0.5)
        }
        try assertMatch(#"<color red="1" green="0.5" blue="0.25" opacity="0.5" />"#, size: .init(width: 50, height: 50)) {
            Color(red: 1, green: 0.5, blue: 0.25, opacity: 0.5)
        }
    }
}
