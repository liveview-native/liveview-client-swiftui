//
//  EdgeInsets.swift
// LiveViewNative
//
//  Created by Shadowfacts on 9/14/22.
//

import SwiftUI

extension EdgeInsets: Decodable {
    public init(from decoder: Decoder) throws {
        if let singleValueContainer = try? decoder.singleValueContainer(),
           let value = try? singleValueContainer.decode(CGFloat.self) {
            self.init(top: value, leading: value, bottom: value, trailing: value)
        } else {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            if let f = try container.decodeIfPresent(CGFloat.self, forKey: .all) {
                self = EdgeInsets(top: f, leading: f, bottom: f, trailing: f)
            } else {
                // TODO: support null for system default padding (requires separate "mode" since default can't be represented by EdgeInsets)
                var insets = EdgeInsets()
                if let f = try container.decodeIfPresent(CGFloat.self, forKey: .top) {
                    insets.top = f
                }
                if let f = try container.decodeIfPresent(CGFloat.self, forKey: .bottom) {
                    insets.bottom = f
                }
                if let f = try container.decodeIfPresent(CGFloat.self, forKey: .leading) {
                    insets.leading = f
                }
                if let f = try container.decodeIfPresent(CGFloat.self, forKey: .trailing) {
                    insets.trailing = f
                }
                self = insets
            }
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case all, top, bottom, leading, trailing
    }
}
