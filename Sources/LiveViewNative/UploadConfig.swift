//
//  File.swift
//  
//
//  Created by Carson.Katri on 5/30/23.
//

import Foundation

public struct UploadConfig: Codable {
    let name: String
    let accept: String
    let ref: String
    let maxEntries: Int
    let chunkSize: Int
}
