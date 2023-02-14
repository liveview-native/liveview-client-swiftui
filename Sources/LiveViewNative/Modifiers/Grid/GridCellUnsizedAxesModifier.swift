//
//  GridCellUnsizedAxesModifier.swift
//
//
//  Created by Carson Katri on 2/14/23.
//

import SwiftUI

struct GridCellUnsizedAxesModifier: ViewModifier, Decodable, Equatable {
    private let axes: Axis.Set
    
    func body(content: Content) -> some View {
        content.gridCellUnsizedAxes(axes)
    }
}
