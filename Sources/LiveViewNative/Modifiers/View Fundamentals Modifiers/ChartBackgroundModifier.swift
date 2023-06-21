//
//  ChartBackgroundModifier.swift
//  
//
//  Created by murtza on 21/06/2023.
//

import Charts
import SwiftUI

/// Adds a background to a view that contains a chart.
///
/// ```html
/// <VStack template={:content} modifiers={chart_background(@native, alignment: :center)}>
///   <chart_background:background>
///     <Color name="system-green" />
///   </chart_background:background>
///   <Chart>Chart Content!</Chart>
/// </VStack>
/// ```
///
/// ## Arguments
/// * ``alignment``
/// * ``content``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct ChartBackgroundModifier<R: RootRegistry>: ViewModifier, Decodable {
    /// The alignment of the content.
    ///
    /// See ``LiveViewNative/SwiftUI/Alignment`` for a list of possible values.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    let alignment: Alignment
    
    /// The content of the background..
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    let content: String?
    
    @ObservedElement private var element
    @LiveContext<R> private var context

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.alignment = try container.decode(Alignment.self, forKey: .alignment)
        self.content = try container.decode(String.self, forKey: .content)
    }

    func body(content: Content) -> some View {
        content.chartBackground(alignment: self.alignment) {_ in 
            context.buildChildren(of: element, forTemplate: self.content!)
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case alignment
        case content
    }
}

