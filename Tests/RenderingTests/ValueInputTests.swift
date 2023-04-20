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
    
    func testSliderSimple() throws {
        try assertMatch(#"<Slider />"#, size: .init(width: 100, height: 100)) {
            Slider(value: .constant(0))
        }
    }
    
    func testSliderLabels() throws {
        try assertMatch(#"""
<Slider>
    <Text template="label">Label</Text>
    <Text template="minimum-value-label">Min</Text>
    <Text template="maximum-value-label">Max</Text>
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
    
    // MARK: Toggle
    
    func testToggleSimple() throws {
        try assertMatch(#"<Toggle>Switch</Toggle>"#) {
            Toggle("Switch", isOn: .constant(false))
        }
    }
    
    // MARK: Stepper
    
    func testStepperSimple() throws {
        try assertMatch(#"<Stepper>Stepper Label</Stepper>"#) {
            Stepper(value: .constant(0)) {
                Text("Stepper Label")
            }
        }
    }
}
