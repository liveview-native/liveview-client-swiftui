import lightpanda
import Foundation

@MainActor
public final class CDP {
    var address: UnsafeMutableRawPointer!
    var pending: [Int:(Result<Data, any Error>) -> ()] = [:]
    var index = 0
    
    private var pageRunLoop: Task<(), any Error>?
    
//    public var eventStream: AsyncStream<Event>!
//    private var eventStreamContinuation: AsyncStream<Event>.Continuation!
    public var eventCallback: (Event, Data) -> () = { _, _ in }
    
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
                _ = self.pageWait(0)
                try await Task.sleep(for: .milliseconds(50))
            }
        }
    }
    
    public func pageWait(_ ms: Int32) -> lightpanda.Session_WaitResult {
        return lightpanda_cdp_page_wait(address, ms)
    }
    
//    public func processMessage<Params: Method>(
//        _ params: Params
//    ) async throws -> Params.Response {
//        // this lets the page process any pending events after the message is sent and responded.
////        defer { _ = self.pageWait(604_800_000) }
//        
//        index += 1
//        let message = Message(id: index, method: Params.method, params: params)
//        return try await withCheckedThrowingContinuation { continuation in
//            pending[message.id] = { result in
//                nonisolated(unsafe) let result = result.flatMap { (data) -> Result<Params.Response, any Error> in
//                    do {
//                        switch try JSONDecoder().decode(MethodResult<Params>.self, from: data) {
//                        case let .success(result):
//                            return .success(result)
//                        case let .failure(error):
//                            return .failure(error)
//                        }
//                    } catch {
//                        return .failure(error)
//                    }
//                }
//                continuation.resume(with: result)
//            }
//            let message = String(data: try! JSONEncoder().encode(message), encoding: .utf8)!
//            print("[SEND]")
//            print(message)
//            print("")
//            lightpanda_cdp_process_message(address, message)
//        }
//    }
    
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
    
    func handleMessage(_ message: UnsafePointer<CChar>?) {
//        print(String(cString: message!))
        print("[RECEIVE]")
        print(String(cString: message!))
        print("")
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
        self.eventCallback(event, data)
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
