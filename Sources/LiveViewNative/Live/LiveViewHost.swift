//
//  LiveViewHost.swift
//  
//
//  Created by Carson Katri on 6/29/23.
//

import Foundation

/// The information needed to locate a server hosting a LiveView.
///
/// This protocol gives quick access to common LiveView hosts.
///
/// For example, use ``LocalhostLiveViewHost/localhost`` to quickly connect to a development server on port `4000`.
///
/// - Note: You can use ``LocalhostLiveViewHost/localhost(port:path:)`` to customize the port and base path of your Phoenix server.
///
/// ```swift
/// struct ContentView: View {
///     var body: some View {
///         LiveView(.localhost)
///     }
/// }
/// ```
///
/// To provide a custom `URL`, use ``CustomLiveViewHost/custom(_:)``.
///
/// - Note: In many cases, it is easier to use ``LiveView/init(url:configuration:)`` to provide a custom URL.
///
/// ```swift
/// struct ContentView: View {
///     var body: some View {
///         LiveView(URL(string: "https://example.com")!)
///     }
/// }
/// ```
///
/// ## Switching Between Development/Production
/// In many cases, a different host should be used for development and production environments.
///
/// Use ``AutomaticLiveViewHost/automatic(_:)`` or ``AutomaticLiveViewHost/automatic(development:production:)`` to easily switch hosts based on the `DEBUG` compiler directive.
///
/// - Note: `DEBUG` is setup by default in new Xcode projects for the debug configuration.
///
/// ```swift
/// struct ContentView: View {
///     var body: some View {
///         LiveView(.automatic(URL(string: "https://example.com")!))
///     }
/// }
/// ```
public protocol LiveViewHost {
    var url: URL { get }
}

public struct LocalhostLiveViewHost: LiveViewHost {
    public let url: URL
    
    init(port: Int = 4000, path: String? = nil) {
        let base = URL(string: "http://localhost:\(port)")!
        if let path {
            self.url = base.appending(path: path)
        } else {
            self.url = base
        }
    }
}

public extension LiveViewHost where Self == LocalhostLiveViewHost {
    /// A server at `http://localhost:4000`.
    static var localhost: Self { .init() }
    /// A server at `localhost` on the given port with a custom base path.
    static func localhost(port: Int = 4000, path: String? = nil) -> Self { .init(port: port, path: path) }
}

public struct CustomLiveViewHost: LiveViewHost {
    public let url: URL
    
    init(_ url: URL) {
        self.url = url
    }
}

public extension LiveViewHost where Self == CustomLiveViewHost {
    /// A server at a custom `URL`.
    static func custom(_ url: URL) -> Self { .init(url) }
}

public struct AutomaticLiveViewHost: LiveViewHost {
    public let url: URL
    
    init(
        development: some LiveViewHost,
        production: some LiveViewHost
    ) {
        #if DEBUG
        self.url = development.url
        #else
        self.url = production.url
        #endif
    }
}

public extension LiveViewHost where Self == AutomaticLiveViewHost {
    /// Automatically select a host based on the `DEBUG` compiler directive.
    static func automatic(development: some LiveViewHost, production: some LiveViewHost) -> Self {
        .init(development: development, production: production)
    }
    
    /// Automatically select a host based on the `DEBUG` compiler directive.
    ///
    /// Provide the `URL` of the production host. The development host defaults to ``LocalhostLiveViewHost/localhost``.
    static func automatic(_ url: URL) -> Self {
        .init(development: .localhost, production: .custom(url))
    }
}

extension URL: LiveViewHost {
    public var url: URL {
        self
    }
}
