//
//  LiveViewCoordinator.swift
//  PhoenixLiveViewNative
//
//  Created by Brian Cardarella on 4/12/21.
//

import Foundation
import SwiftSoup
import SwiftUI
import SwiftPhoenixClient
import Combine

private var PUSH_TIMEOUT: Double = 30000

/// The live view coordinator object handles connecting to Phoenix LiveView on the backend, managing the websocket connection, and transmitting/handling events.
// todo: consider making this an actor, right now there are a number of potential race conditions
public class LiveViewCoordinator<R: CustomRegistry>: ObservableObject {
    /// The current state of the live view connection.
    @Published public private(set) var state: State = .notConnected
    
    /// The first URL this live view was connected to.
    public let initialURL: URL
    /// The current URL this live view is connected to.
    ///
    /// - Note: If you need to use the URL in, e.g., a view with a custom action, you should generally prefer the context's ``LiveContext/url`` because `currentURL` will change upon live navigation and may not reflect the URL of the page your view is actually on.
    public private(set) var currentURL: URL
    internal let replaceRedirectSubject = PassthroughSubject<(URL, URL), Never>()
    internal let config: LiveViewConfiguration
    private var phxSession: String = ""
    private var phxStatic: String = ""
    private var phxView: String = ""
    private var phxID: String = ""
    private var phxCSRFToken: String = ""
    @Published internal var elements: Elements = Elements()
    private var socket: Socket!
    private var channel: Channel!
    private var urlSession: URLSession
    private var rendered: Root!
    private var liveReloadEnabled: Bool = false
    private var liveReloadSocket: Socket?
    private var liveReloadChannel: Channel?
    
    internal let builder: ViewTreeBuilder<R>
    
    /// Creates a new coordinator with a custom registry.
    /// - Parameter url: The URL of the page to establish the connection to.
    /// - Parameter config: The configuration for this coordinator.
    /// - Parameter customRegistry: The registry of custom views this coordinator will use when building the SwiftUI view tree from the DOM.
    public init(_ url: URL, config: LiveViewConfiguration = .init(), customRegistry: R) {
        self.initialURL = url
        self.currentURL = url
        self.config = config
        self.state = .notConnected
        self.urlSession = URLSession.shared
        self.builder = ViewTreeBuilder(customRegistry: customRegistry)
    }
    
    /// Creates a new coordinator without a custom registry.
    /// - Parameter url: The URL of the page to establish the connection to.
    /// - Parameter config: The configuration for this coordinator.
    public convenience init(_ url: URL, config: LiveViewConfiguration = .init()) where R == EmptyRegistry {
        self.init(url, config: config, customRegistry: EmptyRegistry())
    }
    
    /// Connects this coordinator to the LiveView channel.
    ///
    /// This function is a no-op unless ``state-swift.property`` is ``State-swift.enum/notConnected``.
    public func connect() {
        guard case .notConnected = state else {
            return
        }
        
        state = .connecting
        
        fetchDOM() { result in
            switch result {
            case .success(let html):
                do {
                    let doc = try SwiftSoup.parse(html)
                    let elements = doc.body()!.children()
                    self.phxCSRFToken = try! doc.select("meta[name=\"csrf-token\"]")[0].attr("content")
                    self.liveReloadEnabled = !(try! doc.select("iframe[src=\"/phoenix/live_reload/frame\"]").isEmpty())
                    try self.extractDOMValues(elements)
                    self.connectSocket()
                    // todo: should wait until socket as successfully opened before trying to connect the lv
                    self.connectLiveView()
                        
                    DispatchQueue.main.async {
                        do {
                            // todo: the initial html will be wrong if the LiveView is shared btwn native and web; should we ignore it altogether and wait for rendered upon socket connection?
//                            self.elements = try elements.select("div[data-phx-main=\"true\"]")[0].children()
//                            self.state = .connected
                        } catch {
                            self.state = .connectionFailed(FetchError.initialParseError)
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.state = .connectionFailed(FetchError.initialParseError)
                    }
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.state = .connectionFailed(error)
                }
            }
        }
    }
    
    private func reconnect() {
        state = .notConnected
        socket?.disconnect()
        liveReloadSocket?.disconnect()
        connect()
    }
    
    func navigateTo(url: URL, replace: Bool = false) {
        guard self.currentURL != url else { return }
        let oldURL = self.currentURL
        self.currentURL = url
        reconnect()
        if replace {
            replaceRedirectSubject.send((oldURL, url))
        }
    }
    
    func viewTree() -> some View {
        builder.fromElements(self.elements, coordinator: self, url: currentURL)
    }
    
    /// Pushes a LiveView event with the given name and payload to the server.
    ///
    /// The client view tree will be updated automatically when the response is received.
    public func pushEvent(_ event: String, payload: Payload) {
        self.channel.push(event, payload: payload, timeout: PUSH_TIMEOUT).receive("ok") { [weak self] reply in
            guard let self = self,
                  let diffPayload = reply.payload["diff"] as? Payload,
                  let elements = try? self.handleDiff(payload: diffPayload) else {
                      return
                  }
            DispatchQueue.main.async {
                self.elements = elements
            }
        }
    }

    
    private func connectSocket() {
        let cookies = HTTPCookieStorage.shared.cookies(for: self.currentURL)
        
        let configuration = URLSessionConfiguration.default
        for cookie in cookies! {
            configuration.httpCookieStorage!.setCookie(cookie)
        }

        var wsEndpoint = URLComponents(url: currentURL, resolvingAgainstBaseURL: true)!
        wsEndpoint.scheme = currentURL.scheme == "https" ? "wss" : "ws"
        wsEndpoint.path = "/live/websocket"
        self.socket = Socket(endPoint: wsEndpoint.string!, transport: { URLSessionTransport(url: $0, configuration: configuration) }, paramsClosure: {["_csrf_token": self.phxCSRFToken]})
        socket!.onOpen { print("Socket Opened") }
        socket!.onClose { print("Socket Closed") }
        socket!.onError { (error) in print("Socket Error", error) }
        socket!.logger = { message in print("LOG:", message) }
        socket!.connect()
        
        if liveReloadEnabled {
            print("LiveReload: attempting to connect...")
            
            var liveReloadEndpoint = URLComponents(url: currentURL, resolvingAgainstBaseURL: true)!
            liveReloadEndpoint.scheme = currentURL.scheme == "https" ? "wss" : "ws"
            liveReloadEndpoint.path = "/phoenix/live_reload/socket"
            self.liveReloadSocket = Socket(endPoint: liveReloadEndpoint.string!, transport: {
                URLSessionTransport(url: $0, configuration: configuration)
            })
            liveReloadSocket!.connect()
            self.liveReloadChannel = liveReloadSocket!.channel("phoenix:live_reload")
            self.liveReloadChannel!.join().receive("ok") { msg in
                print("LiveReload: connected to channel")
            }.receive("error") { msg in
                print("LiveReload: error connecting to channel: \(msg.payload)")
            }
            self.liveReloadChannel!.on("assets_change") { [unowned self] _ in
                DispatchQueue.main.async {
                    print("LiveReload: assets changed, reloading")
                    // need to fully reconnect (rather than just re-join channel) because the elixir code reloader only triggers on http reqs
                    self.reconnect()
                }
            }
        }
    }
    
    // todo: don't use Any for the params
    private func connectLiveView() {
        var connectParams = config.connectParams?(currentURL) ?? [:]
        connectParams["_mounts"] = 0
        connectParams["_csrf_token"] = self.phxCSRFToken
        connectParams["_native"] = true
        
        self.channel = self.socket.channel("lv:\(self.phxID)", params: ["session": self.phxSession, "static": self.phxStatic, "url": currentURL.absoluteString, "params": connectParams])
        self.channel.join()
            .receive("ok") { message in
                let renderedPayload = (message.payload["rendered"] as! Payload)
                // todo: what should happen if decoding or parsing fails?
                self.rendered = try! Root(from: FragmentDecoder(data: renderedPayload))
                let elements = try! self.parseDOM(html: self.rendered.buildString())
                DispatchQueue.main.async {
                    self.elements = elements
                }
            }
            .receive("error") { message in print("Failed to join", message.payload) }
        self.channel.onError { (payload) in print("Error: ", payload) }
        self.channel.onClose { (payload) in print("Channel Closed") }
        self.channel.on("diff") { (message) in
            let elements = try! self.handleDiff(payload: message.payload)
            DispatchQueue.main.async {
                self.elements = elements
            }
        }
    }
    
    private func extractDOMValues(_ elements: Elements)throws -> Void {
        let mainDiv = try elements.select("div[data-phx-main=\"true\"]")[0]
        self.phxSession = try mainDiv.attr("data-phx-session")
        self.phxStatic = try mainDiv.attr("data-phx-static")
        self.phxView = try mainDiv.attr("data-phx-view")
        self.phxID = try mainDiv.attr("id")
    }
    
    private func fetchDOM(_ completion: @escaping (Result<String, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: self.currentURL) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let data = data, let html = String(data: data, encoding: .utf8) {
                completion(.success(html))
            } else {
                completion(.failure(FetchError.other(response!)))
            }
        }
        
        task.resume()
    }
    
    private func parseDOM(html: String) throws -> Elements {
        let document = try SwiftSoup.parseBodyFragment(html)
        return try document.select("body")[0].children()
    }
    
    private func handleDiff(payload: Payload) throws -> Elements {
        let diff = try RootDiff(from: FragmentDecoder(data: payload))
        self.rendered = try self.rendered.merge(with: diff)
        return try self.parseDOM(html: self.rendered.buildString())
    }
}

extension LiveViewCoordinator {
    /// The live view connection state.
    public enum State {
        /// The coordinator has not yet connected to the live view.
        case notConnected
        /// The coordinator is attempting to connect.
        case connecting
        /// The coordinator has connected and the view tree can be rendered.
        case connected
        // todo: disconnected state?
        /// The coordinator failed to connect and produced the given error.
        case connectionFailed(Error)
    }
}

extension LiveViewCoordinator {
    enum FetchError: Error {
        /// An error encountered when parsing the initial HTML.
        case initialParseError
        case other(URLResponse)
    }
}
