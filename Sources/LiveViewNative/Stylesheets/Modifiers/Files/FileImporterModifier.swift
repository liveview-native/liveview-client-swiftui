//
//  FileImporterModifier.swift
//
//
//  Created by Carson Katri on 10/23/24.
//

import SwiftUI
import LiveViewNativeCore
import LiveViewNativeStylesheet
import UniformTypeIdentifiers
import OSLog

private let logger = Logger(subsystem: "LiveViewNative", category: "_FileImporterModifier")

/// See [`SwiftUI.View/fileImporter(isPresented:allowedContentTypes:allowsMultipleSelection:onCompletion:)`](https://developer.apple.com/documentation/swiftui/view/fileimporter(ispresented:allowedcontenttypes:allowsmultipleselection:oncompletion:)) for more details on this ViewModifier.
///
/// ### fileImporter(isPresented:allowedContentTypes:allowsMultipleSelection:onCompletion:)
/// - `isPresented`: `attr("...")` (required)
/// - `allowedContentTypes`: `attr("...")` or list of ``UniformTypeIdentifiers/UTType`` (required)
/// - `allowsMultipleSelection`: `attr("...")` or ``Swift/Bool`` (required)
///
/// See [`SwiftUI.View/fileImporter(isPresented:allowedContentTypes:allowsMultipleSelection:onCompletion:)`](https://developer.apple.com/documentation/swiftui/view/fileimporter(ispresented:allowedcontenttypes:allowsmultipleselection:oncompletion:)) for more details on this ViewModifier.
///
/// Example:
///
/// ```heex
/// <.live_file_input upload={@uploads.avatar} />
/// ```
@_documentation(visibility: public)
@ParseableExpression
struct _FileImporterModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "fileImporter" }
    
    @Environment(\.formModel) private var formModel
    
    private let id: AttributeReference<String>
    private let name: AttributeReference<String>
    @ChangeTracked private var isPresented: Bool
    private let allowedContentTypes: AttributeReference<UTType.ResolvableSet>
    private let allowsMultipleSelection: AttributeReference<Bool>
    
    @ObservedElement private var element
    @LiveContext<R> private var context

    @available(iOS 14.0, macOS 11.0, visionOS 1.0, *)
    init(
        id: AttributeReference<String>,
        name: AttributeReference<String>,
        isPresented: ChangeTracked<Bool>,
        allowedContentTypes: AttributeReference<UTType.ResolvableSet>,
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
            allowedContentTypes: allowedContentTypes.resolve(on: element, in: context).values,
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

extension UTType: AttributeDecodable {
    struct ResolvableSet: AttributeDecodable, ParseableModifierValue {
        nonisolated let values: [UTType]
        
        init(values: [UTType]) {
            self.values = values
        }
        
        nonisolated init(from attribute: LiveViewNativeCore.Attribute?, on element: ElementNode) throws {
            guard let value = attribute?.value
            else { throw AttributeDecodingError.missingAttribute(Self.self) }
            self.values = value.split(separator: ",").compactMap({ UTType(filenameExtension: String($0.dropFirst())) })
        }
        
        static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
            Array<String>.parser(in: context).compactMap({ Self.init(values: $0.compactMap(UTType.init)) })
        }
    }
}
