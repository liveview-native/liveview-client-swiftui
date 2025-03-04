//
//  FileImporter.swift
//  LiveViewNative
//
//  Created by Carson.Katri on 2/27/25.
//

#if os(iOS) || os(macOS) || os(visionOS)
import SwiftUI
import LiveViewNativeCore
import LiveViewNativeStylesheet
import UniformTypeIdentifiers
import OSLog

private let logger = Logger(subsystem: "LiveViewNative", category: "FileImporterModifier")

@ASTDecodable("fileImporter")
@available(iOS 14.0, macOS 11.0, visionOS 1.0, *)
struct FileImporterModifier<R: RootRegistry>: @preconcurrency Decodable, ViewModifier {
    @Environment(\.formModel) private var formModel
    
    private let id: AttributeReference<String>
    private let name: AttributeReference<String>
    @ChangeTracked private var isPresented: Bool
    private let allowedContentTypes: AttributeReference<AllowedContentTypes>
    private let allowsMultipleSelection: AttributeReference<Bool>
    
    @ObservedElement private var element
    @LiveContext<R> private var context
    
    struct AllowedContentTypes: @preconcurrency Decodable, @preconcurrency AttributeDecodable {
        let value: [UTType]
        
        init(from attribute: Attribute?, on element: ElementNode) throws {
            self.value = attribute?.value?.split(separator: ",")
                .flatMap({ UTType(filenameExtension: String($0.drop(while: { $0 == "." }))) })
                ?? []
        }
        
        init(from decoder: any Decoder) throws {
            self.value = try decoder.singleValueContainer().decode([UTType].self)
        }
    }
    
    init(
        id: AttributeReference<String>,
        name: AttributeReference<String>,
        isPresented: ChangeTracked<Bool>,
        allowedContentTypes: AttributeReference<AllowedContentTypes>,
        allowsMultipleSelection: AttributeReference<Bool>
    ) {
        self.id = id
        self.name = name
        self._isPresented = isPresented
        self.allowedContentTypes = allowedContentTypes
        self.allowsMultipleSelection = allowsMultipleSelection
    }

    func body(content: Content) -> some View {
        #if os(iOS) || os(macOS) || os(visionOS)
        content.fileImporter(
            isPresented: $isPresented,
            allowedContentTypes: allowedContentTypes
                .resolve(on: element, in: context)
                .value,
            allowsMultipleSelection: allowsMultipleSelection.resolve(on: element, in: context)
        ) { result in
            let id = id.resolve(on: element, in: context)
            
            Task {
                do {
                    for url in try result.get() {
                        try await formModel?.queueFileUpload(name: name.resolve(on: element, in: context), id: id, url: url, coordinator: context.coordinator)
                    }
                } catch {
                    logger.log(level: .error, "\(error.localizedDescription)")
                }
            }
        }
        #else
        content
        #endif
    }
}
#endif
