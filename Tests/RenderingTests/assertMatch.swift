//
//  assertMatch.swift
//  
//
//  Created by Carson Katri on 1/10/23.
//

import XCTest
import SwiftUI
import Foundation
@testable import LiveViewNative
import LiveViewNativeCore

@MainActor
func assertMatch(
    _ markup: String,
    _ function: String = #function,
    _ file: String = #file,
    _ line: Int = #line,
    @ViewBuilder _ view: () -> some View
) throws {
    let coordinator = LiveViewCoordinator(URL(string: "http://localhost")!)
    let document = try LiveViewNativeCore.Document.parse(markup)
    let viewTree = coordinator.builder.fromNodes(
        document[document.root()].children(),
        context: LiveContext(coordinator: coordinator, url: coordinator.currentURL)
    ).environment(\.coordinatorEnvironment, CoordinatorEnvironment(coordinator, document: document))
    let markupImage = ImageRenderer(content: viewTree).uiImage?.pngData()
    let viewImage = ImageRenderer(content: view()).uiImage?.pngData()
    
    if markupImage == viewImage {
        XCTAssert(true)
    } else {
        let infoPath = "\(URL(filePath: file).lastPathComponent):\(line)-\(function)"
        let markupURL = URL.temporaryDirectory.appendingPathComponent("\(infoPath)_markup", conformingTo: .png)
        let viewURL = URL.temporaryDirectory.appendingPathComponent("\(infoPath)_view", conformingTo: .png)
        try markupImage?.write(to: markupURL)
        try viewImage?.write(to: viewURL)
        XCTAssert(false, "Rendered views did not match. Outputs saved to \(markupURL.path()) and \(viewURL.path())")
    }
}
