//
//  GridCellAnchorModifier.swift
//
//
//  Created by Carson Katri on 2/14/23.
//

import SwiftUI

struct GridCellAnchorModifier: ViewModifier, Decodable, Equatable {
    private let anchor: UnitPoint
    
    func body(content: Content) -> some View {
        content.gridCellAnchor(anchor)
    }
}
