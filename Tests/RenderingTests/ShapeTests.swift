//
//  ShapeTests.swift
//  
//
//  Created by Carson Katri on 1/18/23.
//

import XCTest
import SwiftUI
import LiveViewNative

@MainActor
final class ShapeTests: XCTestCase {
    func testRectangle() throws {
        try assertMatch(#"<Rectangle />"#) {
            Rectangle()
        }
    }
    
    func testRoundedRectangle() throws {
        try assertMatch(#"<RoundedRectangle cornerRadius="5" />"#, size: .init(width: 100, height: 50)) {
            RoundedRectangle(cornerRadius: 5, style: .circular)
        }
        try assertMatch(#"<RoundedRectangle cornerWidth="5" cornerHeight="10" />"#, size: .init(width: 100, height: 50)) {
            RoundedRectangle(cornerSize: .init(width: 5, height: 10), style: .circular)
        }
        try assertMatch(#"<RoundedRectangle cornerWidth="5" cornerRadius="15" />"#, size: .init(width: 100, height: 50)) {
            RoundedRectangle(cornerSize: .init(width: 5, height: 15), style: .circular)
        }
        try assertMatch(#"<RoundedRectangle cornerHeight="5" cornerRadius="15" />"#, size: .init(width: 100, height: 50)) {
            RoundedRectangle(cornerSize: .init(width: 15, height: 5), style: .circular)
        }
        try assertMatch(#"<RoundedRectangle cornerRadius="10" style="continuous" />"#, size: .init(width: 100, height: 50)) {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
        }
    }
    
    func testCircle() throws {
        try assertMatch(#"<Circle />"#) {
            Circle()
        }
    }
    
    func testEllipse() throws {
        try assertMatch(#"<Ellipse />"#, size: .init(width: 100, height: 50)) {
            Ellipse()
        }
    }
    
    func testCapsule() throws {
        try assertMatch(#"<Capsule />"#, size: .init(width: 100, height: 50)) {
            Capsule(style: .circular)
        }
        try assertMatch(#"<Capsule />"#, size: .init(width: 50, height: 100)) {
            Capsule(style: .circular)
        }
        try assertMatch(#"<Capsule style="continuous" />"#, size: .init(width: 100, height: 50)) {
            Capsule(style: .continuous)
        }
    }
    
    func testContainerRelativeShape() throws {
        try assertMatch(#"<ContainerRelativeShape />"#) {
            ContainerRelativeShape()
        }
    }
    
    // MARK: Color
    
    func testSystemColor() throws {
        try assertMatch(#"<Color name="system-red" />"#, size: .init(width: 50, height: 50)) {
            Color.red
        }
    }
    
    func testRGBColor() throws {
        try assertMatch(#"<Color red="1" green="0.5" blue="0.25" />"#, size: .init(width: 50, height: 50)) {
            Color(red: 1, green: 0.5, blue: 0.25)
        }
    }
    
    func testRGBColorSpace() throws {
        try assertMatch(#"<Color red="1" green="0.5" blue="0.25" colorSpace="sRGB" />"#, size: .init(width: 50, height: 50)) {
            Color(.sRGB, red: 1, green: 0.5, blue: 0.25)
        }
        try assertMatch(#"<Color red="1" green="0.5" blue="0.25" colorSpace="sRGBLinear" />"#, size: .init(width: 50, height: 50)) {
            Color(.sRGBLinear, red: 1, green: 0.5, blue: 0.25)
        }
        try assertMatch(#"<Color red="1" green="0.5" blue="0.25" colorSpace="displayP3" />"#, size: .init(width: 50, height: 50)) {
            Color(.displayP3, red: 1, green: 0.5, blue: 0.25)
        }
    }
    
    func testColorOpacity() throws {
        try assertMatch(#"<Color name="system-red" opacity="0.5" />"#, size: .init(width: 50, height: 50)) {
            Color.red.opacity(0.5)
        }
        try assertMatch(#"<Color red="1" green="0.5" blue="0.25" opacity="0.5" />"#, size: .init(width: 50, height: 50)) {
            Color(red: 1, green: 0.5, blue: 0.25, opacity: 0.5)
        }
    }
}
