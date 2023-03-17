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
        try assertMatch(#"<Gauge value="0.25" lower-bound="0.1" upper-bound="2">0.25</Gauge>"#, size: .init(width: 100, height: 50), lifetime: .keepAlways) {
            Gauge(value: 0.25, in: 0.1...2) {
                Text("0.25")
            }
        }
    }
    
    func testGaugeStyle() throws {
        try assertMatch(#"<Gauge value="0.5" gauge-style="accessory-circular-capacity">50%</Gauge>"#) {
            Gauge(value: 0.5) {
                Text("50%")
            }
                .gaugeStyle(.accessoryCircularCapacity)
        }
        try assertMatch(#"<Gauge value="0.5" gauge-style="accessory-linear-capacity">50%</Gauge>"#) {
            Gauge(value: 0.5) {
                Text("50%")
            }
                .gaugeStyle(.accessoryLinearCapacity)
        }
        try assertMatch(#"<Gauge value="0.5" gauge-style="accessory-circular">50%</Gauge>"#) {
            Gauge(value: 0.5) {
                Text("50%")
            }
                .gaugeStyle(.accessoryCircular)
        }
        try assertMatch(#"<Gauge value="0.5" gauge-style="automatic">50%</Gauge>"#) {
            Gauge(value: 0.5) {
                Text("50%")
            }
                .gaugeStyle(.automatic)
        }
        try assertMatch(#"<Gauge value="0.5" gauge-style="linear-capacity">50%</Gauge>"#) {
            Gauge(value: 0.5) {
                Text("50%")
            }
                .gaugeStyle(.linearCapacity)
        }
        try assertMatch(#"<Gauge value="0.5" gauge-style="accessory-linear">50%</Gauge>"#) {
            Gauge(value: 0.5) {
                Text("50%")
            }
                .gaugeStyle(.accessoryLinear)
        }
    }
    
    func testGaugeSlots() throws {
        try assertMatch(
            #"""
            <Gauge value="0.5">
                <Gauge:label>50%</Gauge:label>
                <Gauge:current-value-label>0.5</Gauge:current-value-label>
                <Gauge:minimum-value-label>0</Gauge:minimum-value-label>
                <Gauge:maximum-value-label>1</Gauge:maximum-value-label>
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
                <Gauge:current-value-label>0.5</Gauge:current-value-label>
                <Gauge:minimum-value-label>0</Gauge:minimum-value-label>
                <Gauge:maximum-value-label>1</Gauge:maximum-value-label>
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
