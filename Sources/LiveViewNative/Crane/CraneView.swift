import SwiftUI
import Crane
@preconcurrency import LiveViewNativeCore
@preconcurrency import LiveViewNativeStylesheet

public struct DocumentView<R: RootRegistry>: View {
    @StateObject private var session: CraneSession
    let document: LiveViewNativeCore.Document?
    let stylesheet: Stylesheet<R>?
    
    public init(url: URL, document: Document, stylesheet: Stylesheet<R>?) {
        self.document = document
        self.stylesheet = stylesheet
        self._session = .init(wrappedValue: .init(url))
    }
    
    public var body: some View {
        if let document {
            let coordinator = CraneCoordinator(
                session: session,
                url: session.url,
                document: document
            )
            ViewTreeBuilder<R>().fromNodes(document[document.root()].children(), coordinator: coordinator, url: self.session.url)
                .environment(\.coordinatorEnvironment, CoordinatorEnvironment(coordinator, document: document))
                .environment(\.stylesheet, stylesheet)
        } else {
            SwiftUI.ProgressView(session.url.host() ?? "")
        }
    }
    
    final class CraneSession: LiveSessionCoordinator<R> {}
    
    final class CraneCoordinator: LiveViewCoordinator<R> {
        init(
            session: CraneSession,
            url: URL,
            document: Document
        ) {
            super.init(session: session, url: url)
            self.document = document
        }
    }
}
