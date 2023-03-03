//
//  RenameActionModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 3/3/23.
//

import SwiftUI

struct RenameActionModifier: ViewModifier, Decodable {
    private let event: String
    private let target: Int?
    @Environment(\.coordinatorEnvironment) private var coordinatorEnvironment

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.event = try container.decode(String.self, forKey: .event)
        self.target = try container.decode(Int?.self, forKey: .target)
    }

    private enum CodingKeys: String, CodingKey {
        case event
        case target
    }
    
    func body(content: Content) -> some View {
        content
            .renameAction {
                Task {
                    // FIXME: Pass the target once that is available.
                    try await coordinatorEnvironment?.pushEvent("click", event, [String:Any]())
                }
            }
    }
}
