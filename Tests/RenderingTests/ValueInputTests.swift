//
//  ValueInputTests.swift
//
//
//  Created by Carson Katri on 1/26/23.
//

import XCTest
import SwiftUI
import LiveViewNative

@MainActor
final class ValueInputTests: XCTestCase {
    // MARK: Slider
    
    #if !os(tvOS)
    func testSliderSimple() throws {
        try assertMatch(#"<Slider />"#, size: .init(width: 100, height: 100)) {
            Slider(value: .constant(0))
        }
    }
    
    func testSliderLabels() throws {
        try assertMatch(#"""
<Slider>
    <Text template="label">Label</Text>
    <Text template="minimumValueLabel">Min</Text>
    <Text template="maximumValueLabel">Max</Text>
</Slider>
"""#, size: .init(width: 300, height: 100)) {
            Slider(value: .constant(0)) {
                Text("Label")
            } minimumValueLabel: {
                Text("Min")
            } maximumValueLabel: {
                Text("Max")
            }
        }
    }
    #endif
    
    // MARK: Toggle
    
    func testToggleSimple() throws {
        try assertMatch(#"<Toggle>Switch</Toggle>"#) {
            Toggle("Switch", isOn: .constant(false))
        }
    }
    
    // MARK: Stepper
    #if !os(tvOS)
    func testStepperSimple() throws {
        try assertMatch(#"<Stepper>Stepper Label</Stepper>"#) {
            Stepper(value: .constant(0)) {
                Text("Stepper Label")
            }
        }
    }
    #endif
}
