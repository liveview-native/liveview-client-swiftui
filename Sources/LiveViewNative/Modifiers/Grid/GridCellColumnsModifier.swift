//
//  GridCellColumnsModifier.swift
//
//
//  Created by Carson Katri on 2/14/23.
//

import SwiftUI

struct GridCellColumnsModifier: ViewModifier, Decodable, Equatable {
    private let count: Int
    
    func body(content: Content) -> some View {
        content.gridCellColumns(count)
    }
}
