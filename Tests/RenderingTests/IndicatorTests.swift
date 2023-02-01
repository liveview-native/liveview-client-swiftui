//
//  IndicatorTests.swift
//  
//
//  Created by Carson Katri on 1/17/23.
//

import XCTest
import SwiftUI
@testable import LiveViewNative

@MainActor
final class IndicatorTests: XCTestCase {
    func testProgressViewValue() throws {
        try assertMatch(#"<progress-view value="0.5" />"#, size: .init(width: 200, height: 200)) {
            ProgressView(value: 0.5)
        }
    }
    
    func testProgressViewTotal() throws {
        try assertMatch(#"<progress-view value="2.5" total="5" />"#, size: .init(width: 200, height: 200)) {
            ProgressView(value: 2.5, total: 5)
        }
    }
    
#if !os(tvOS)
    func testGaugeSimple() throws {
        try assertMatch(#"<gauge value="0.25">25%</gauge>"#, size: .init(width: 100, height: 50)) {
            Gauge(value: 0.25) {
                Text("25%")
            }
        }
    }
    
    func testGaugeBounds() throws {
        try assertMatch(#"<gauge value="0.25" lower-bound="0.1" upper-bound="2">0.25</gauge>"#, size: .init(width: 100, height: 50), lifetime: .keepAlways) {
            Gauge(value: 0.25, in: 0.1...2) {
                Text("0.25")
            }
        }
    }
    
    func testGaugeStyle() throws {
        try assertMatch(#"<gauge value="0.5" gauge-style="accessory-circular-capacity">50%</gauge>"#) {
            Gauge(value: 0.5) {
                Text("50%")
            }
                .gaugeStyle(.accessoryCircularCapacity)
        }
        try assertMatch(#"<gauge value="0.5" gauge-style="accessory-linear-capacity">50%</gauge>"#) {
            Gauge(value: 0.5) {
                Text("50%")
            }
                .gaugeStyle(.accessoryLinearCapacity)
        }
        try assertMatch(#"<gauge value="0.5" gauge-style="accessory-circular">50%</gauge>"#) {
            Gauge(value: 0.5) {
                Text("50%")
            }
                .gaugeStyle(.accessoryCircular)
        }
        try assertMatch(#"<gauge value="0.5" gauge-style="automatic">50%</gauge>"#) {
            Gauge(value: 0.5) {
                Text("50%")
            }
                .gaugeStyle(.automatic)
        }
        try assertMatch(#"<gauge value="0.5" gauge-style="linear-capacity">50%</gauge>"#) {
            Gauge(value: 0.5) {
                Text("50%")
            }
                .gaugeStyle(.linearCapacity)
        }
        try assertMatch(#"<gauge value="0.5" gauge-style="accessory-linear">50%</gauge>"#) {
            Gauge(value: 0.5) {
                Text("50%")
            }
                .gaugeStyle(.accessoryLinear)
        }
    }
    
    func testGaugeSlots() throws {
        try assertMatch(
            #"""
            <gauge value="0.5">
                <gauge:label>50%</gauge:label>
                <gauge:current-value-label>0.5</gauge:current-value-label>
                <gauge:minimum-value-label>0</gauge:minimum-value-label>
                <gauge:maximum-value-label>1</gauge:maximum-value-label>
            </gauge>
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
            <gauge value="0.5">
                50%
                <gauge:current-value-label>0.5</gauge:current-value-label>
                <gauge:minimum-value-label>0</gauge:minimum-value-label>
                <gauge:maximum-value-label>1</gauge:maximum-value-label>
            </gauge>
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
