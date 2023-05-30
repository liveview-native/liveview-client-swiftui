//
//  FileImporterModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 5/30/2023.
//

import SwiftUI
import UniformTypeIdentifiers

/// <#Documentation#>
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct FileImporterModifier<R: RootRegistry>: ViewModifier, Decodable {
    @LiveContext<R> private var context
    
    /// <#Documentation#>
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @LiveBinding private var isPresented: Bool

    /// <#Documentation#>
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let upload: UploadConfig
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._isPresented = try .init(decoding: .isPresented, in: container)
        self.upload = try container.decode(UploadConfig.self, forKey: .upload)
    }
    
    func body(content: Content) -> some View {
        content
            .fileImporter(
                isPresented: $isPresented,
                allowedContentTypes: upload.accept
                    .split(separator: ",")
                    .map { String($0.trimmingPrefix(".")) }
                    .compactMap({ UTType(tag: $0, tagClass: .filenameExtension, conformingTo: nil) }),
                allowsMultipleSelection: upload.maxEntries > 1
            ) { result in
                switch result {
                case .success(let success):
                    Task {
                        try await context.coordinator.uploadFiles(success, for: upload)
                    }
                case .failure(let failure):
                    fatalError(failure.localizedDescription)
                }
            }
    }

    enum CodingKeys: String, CodingKey {
        case isPresented
        case upload
    }
}

