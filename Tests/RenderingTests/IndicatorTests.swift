//
//  IndicatorTests.swift
//  
//
//  Created by Carson Katri on 1/17/23.
//

import XCTest
import SwiftUI
import LiveViewNative

@MainActor
final class IndicatorTests: XCTestCase {
    func testProgressViewValue() throws {
        try assertMatch(#"<ProgressView value="0.5" />"#, size: .init(width: 200, height: 200)) {
            ProgressView(value: 0.5)
        }
    }
    
    func testProgressViewTotal() throws {
        try assertMatch(#"<ProgressView value="2.5" total="5" />"#, size: .init(width: 200, height: 200)) {
            ProgressView(value: 2.5, total: 5)
        }
    }
    
#if !os(tvOS)
    func testGaugeSimple() throws {
        try assertMatch(#"<Gauge value="0.25">25%</Gauge>"#, size: .init(width: 100, height: 50)) {
            Gauge(value: 0.25) {
                Text("25%")
            }
        }
    }
    
    func testGaugeBounds() throws {
        try assertMatch(#"<Gauge value="0.25" lowerBound="0.1" upperBound="2">0.25</Gauge>"#, size: .init(width: 100, height: 50), lifetime: .keepAlways) {
            Gauge(value: 0.25, in: 0.1...2) {
                Text("0.25")
            }
        }
    }
    
    func testGaugeSlots() throws {
        try assertMatch(
            #"""
            <Gauge value="0.5">
                <Text template="label">50%</Text>
                <Text template="currentValueLabel">0.5</Text>
                <Text template="minimumValueLabel">0</Text>
                <Text template="maximumValueLabel">1</Text>
            </Gauge>
            """#
        ) {
            Gauge(value: 0.5) {
                Text("50%")
            } currentValueLabel: {
                Text("0.5")
            } minimumValueLabel: {
                Text("0")
            } maximumValueLabel: {
                Text("1")
            }
        }
        
        try assertMatch(
            #"""
            <Gauge value="0.5">
                50%
                <Text template="currentValueLabel">0.5</Text>
                <Text template="minimumValueLabel">0</GText>
                <Text template="maximumValueLabel">1</GText>
            </Gauge>
            """#
        ) {
            Gauge(value: 0.5) {
                Text("50%")
            } currentValueLabel: {
                Text("0.5")
            } minimumValueLabel: {
                Text("0")
            } maximumValueLabel: {
                Text("1")
            }
        }
    }
#endif
}
