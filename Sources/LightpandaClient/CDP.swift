import lightpanda
import Foundation

@MainActor
@Observable
public final class CDP {
    var address: UnsafeMutableRawPointer!
    var pending: [Int:CheckedContinuation<Data, any Error>] = [:]
    var index = 0
    
    private var pageRunLoop: Task<(), any Error>?
    
//    public var eventStream: AsyncStream<Event>!
//    private var eventStreamContinuation: AsyncStream<Event>.Continuation!
    public var eventCallback: @MainActor (Event, Data) -> () = { _, _ in }
    
    public var focusedNode: Node.ID?
    
    public var pausedInDebuggerMessage: String?
    
    init() {}
    
    @MainActor
    deinit {
        lightpanda_cdp_deinit(address)
    }
    
    public func createBrowserContext() -> String {
        return String(cString: lightpanda_cdp_create_browser_context(address))
    }
    
    public var browser: Browser {
        Browser(address: lightpanda_cdp_browser(address))
    }
    
    public var browserContext: BrowserContext {
        BrowserContext(address: lightpanda_cdp_browser_context(address))
    }
    
    public func startPageRunLoop() {
        pageRunLoop = Task {
            while !Task.isCancelled {
                let delay = self.pageWait(0)
                try await Task.sleep(for: .milliseconds(delay))
            }
        }
    }
    
    public func startDevTools() {
        lightpanda_devtools_init(self.address)
    }
    
    public func pageWait(_ ms: Int32) -> Int32 {
        return lightpanda_cdp_page_wait(address, ms)
    }
    
    public func buildMessage<Params: Method>(
        _ params: Params
    ) -> Message<Params> {
        index += 1
        return Message(id: index, method: Params.method, params: params)
    }
    
    @discardableResult
    public func sendMessage<Params: Method>(
        _ message: Message<Params>
    ) {
        lightpanda_cdp_process_message(address, String(data: try! JSONEncoder().encode(message), encoding: .utf8)!)
    }
    
    public func send<Params: Method>(
        _ params: Params
    ) async throws -> Params.Response {
        let message = self.buildMessage(params)
        let data: Data = try await withCheckedThrowingContinuation { continuation in
            self.pending[message.id] = continuation
            self.sendMessage(message)
        }
        let result = try JSONDecoder().decode(MethodResult<Params>.self, from: data)
        switch result {
        case let .failure(error):
            throw error
        case let .success(response):
            return response
        }
    }
    
    func handleMessage(_ message: UnsafePointer<CChar>?) {
//        print(String(cString: message!))
        print("[RECEIVE]")
        print(String(cString: message!))
        print("")
//        let data = Data(bytes: UnsafeMutableRawPointer(mutating: message!), count: strlen(message!))
        let data = Data(
            bytesNoCopy: UnsafeMutableRawPointer(mutating: message!),
            count: strlen(message!),
            deallocator: .none
        )
        if data.isEmpty {
            return
        }
        let event = try! JSONDecoder().decode(
            Event.self,
            from: data
        )
        if case let .result(id) = event,
           let continuation = pending[id]
        {
            pending.removeValue(forKey: id)
            continuation.resume(returning: Data(data))
        } else {
            self.eventCallback(event, data)
        }
//        switch event {
//        case let .result(id):
//            if let continuation = pending[id] {
//                continuation(.success(data))
//            }
//        default:
////            self.eventStreamContinuation.yield(event)
//            self.eventCallback(event)
//        }
    }
    
    public struct Message<Params: Method>: Encodable {
        let id: Int
        let method: String
        let params: Params
    }
    
    enum MethodResult<Params: Method>: Decodable {
        case success(Params.Response)
        case failure(MethodError)
        
        enum CodingKeys: String, CodingKey {
            case result
            case error
        }
        
        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            if container.contains(.result) {
                self = .success(try container.decode(Params.Response.self, forKey: .result))
            } else {
                self = .failure(try container.decode(MethodError.self, forKey: .error))
            }
        }
    }
    
    struct MethodError: Error, Decodable {
        let code: Int
        let message: String
    }

    public enum Event: Decodable {
        case result(id: Int)
        case targetCreated(Target.TargetCreated)
        case documentUpdated
        case attributeModified(DOM.AttributeModified)
        case attributeRemoved(DOM.AttributeRemoved)
        case characterDataModified(DOM.CharacterDataModified)
        case childNodeInserted(DOM.ChildNodeInserted)
        case childNodeRemoved(DOM.ChildNodeRemoved)
        case unknown(method: String)
        
        enum CodingKeys: String, CodingKey {
            case id
            case method
            case params
        }
        
        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            if container.contains(.id) { // method result
                self = .result(id: try container.decode(Int.self, forKey: .id))
            } else { // event
                switch try container.decode(String.self, forKey: .method) {
                case "Target.targetCreated":
                    self = .targetCreated(try container.decode(Target.TargetCreated.self, forKey: .params))
                case "DOM.documentUpdated":
                    self = .documentUpdated
                case "DOM.attributeModified":
                    self = .attributeModified(try container.decode(DOM.AttributeModified.self, forKey: .params))
                case "DOM.attributeRemoved":
                    self = .attributeRemoved(try container.decode(DOM.AttributeRemoved.self, forKey: .params))
                case "DOM.characterDataModified":
                    self = .characterDataModified(try container.decode(DOM.CharacterDataModified.self, forKey: .params))
                case "DOM.childNodeInserted":
                    self = .childNodeInserted(try container.decode(DOM.ChildNodeInserted.self, forKey: .params))
                case "DOM.childNodeRemoved":
                    self = .childNodeRemoved(try container.decode(DOM.ChildNodeRemoved.self, forKey: .params))
                case let method:
                    self = .unknown(method: method)
                }
            }
        }
    }

    public protocol Method: Encodable {
        static var method: String { get }
        associatedtype Response: Decodable
    }
}
