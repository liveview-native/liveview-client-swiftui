//
//  ScaledMetric.swift
//  LiveViewNative
//
//  Created by Carson Katri on 5/30/23.
//

import SwiftUI

///
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct ScaledMetric<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    @LiveContext<R> private var context
    
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @LiveBinding(attribute: "scaled-value-binding") private var scaledValue: Double
    
    @Attribute("value") private var value: Double
    
    @Attribute("relative-to") private var relativeStyle: Font.TextStyle = .body
    
    var body: some View {
        ScaledMetricObserver(
            scaledMetric: .init(wrappedValue: value, relativeTo: relativeStyle),
            value: $scaledValue,
            content: context.buildChildren(of: element)
        )
    }
    
    private struct ScaledMetricObserver<Content: View>: View {
        let scaledMetric: SwiftUI.ScaledMetric<Double>
        @Binding var value: Double
        let content: Content
        
        var body: some View {
            content
                .task(id: scaledMetric.wrappedValue) {
                    value = scaledMetric.wrappedValue
                }
        }
    }
}
