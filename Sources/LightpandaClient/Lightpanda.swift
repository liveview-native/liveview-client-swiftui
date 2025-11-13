import lightpanda
import Foundation
import Observation

#if os(Android)
import Android

private let ANDROID_LOG_INFO: Int32 = 4

/// Redirects stdout and stderr to Android's Logcat.
/// Call this early (e.g., from your JNI entrypoint or Swift runtime initializer).
public func redirectStdoutToLogcat(tag: String = "SwiftNative") {
    var pipefd: [Int32] = [0, 0]
    guard pipe(&pipefd) == 0 else { return }

    // Duplicate pipe write-end to stdout and stderr
    dup2(pipefd[1], STDOUT_FILENO)
    dup2(pipefd[1], STDERR_FILENO)
    setvbuf(stdout, nil, _IOLBF, 0)
    setvbuf(stderr, nil, _IOLBF, 0)

    let readFD = pipefd[0]
    let tagCString = strdup(tag)

    // Spawn a background thread to read from the pipe and write to Logcat
    Thread.detachNewThread {
        var buffer = [CChar](repeating: 0, count: 1024)
        while true {
            let count = read(readFD, &buffer, buffer.count - 1)
            if count <= 0 { break }
            buffer[count] = 0
            __android_log_write(ANDROID_LOG_INFO, tagCString!, buffer)
        }
        free(tagCString)
    }
}
#endif

final class Lightpanda {
    var address: UnsafeMutableRawPointer!
    
    init() {
        self.address = lightpanda_app_init()
    }
    
    
    deinit {
        lightpanda_app_deinit(address)
    }
    
    func makeBrowser() -> Browser {
        return Browser(address: lightpanda_browser_init(self.address))
    }
    
    func makeCDP() -> CDP {
        let cdp = CDP()
        cdp.address = lightpanda_cdp_init(self.address, { [] ctx, message in
            // handle message
            Unmanaged<CDP>.fromOpaque(ctx!).takeUnretainedValue().handleMessage(message)
        }, { [] ctx, nodeId in
            // focus node
            Unmanaged<CDP>.fromOpaque(ctx!).takeUnretainedValue().focusedNode = Node.ID(nodeId)
        }, { [] ctx, message in
            // paused in debugger message
            // NOTE: this doesn't work because the pause loop blocks the main thread
            Unmanaged<CDP>.fromOpaque(ctx!).takeUnretainedValue().pausedInDebuggerMessage = message.flatMap(String.init(cString:))
        }, Unmanaged.passUnretained(cdp).toOpaque())
        return cdp
    }
}

public final class NodeRegistry {
    public var nodes = [Int:Node]()
}

public enum NodeType: Int, Codable, Sendable {
    case element = 1
    case attribute = 2
    case text = 3
    case cdataSection = 4
    case processingInstruction = 7
    case comment = 8
    case document = 9
    case documentType = 10
    case documentFragment = 11
}

@Observable
public class Node: Identifiable {
    public var id: Int
    
    public var type: NodeType
    
    public var name: String
    
    public var value: String
    
    public var childNodeCount: Int?
    
    public var children: [Node]
    
    public var attributes: [String:String] = [:]
    
    public weak var parent: Node?
    
    init(registry: NodeRegistry, id: Int, type: NodeType, name: String, value: String, childNodeCount: Int? = nil, children: [Node] = [], attributes: [String:String] = [:], parent: Node? = nil) {
        self.id = id
        self.type = type
        self.name = name
        self.value = value
        self.childNodeCount = childNodeCount
        self.children = children
        self.attributes = attributes
        self.parent = parent
        
        registry.nodes[id] = self
    }
    
    init(from cdpNode: CDP.DOM.Node, registry: NodeRegistry) {
        self.id = cdpNode.id
        self.type = cdpNode.nodeType
        self.name = cdpNode.nodeName
        self.value = cdpNode.nodeValue
        self.childNodeCount = cdpNode.childNodeCount
        
        self.children = []
        for child in (cdpNode.children ?? []) {
            let childNode = Node(from: child, registry: registry)
            childNode.parent = self
            self.children.append(childNode)
        }
        
        self.attributes = cdpNode.attributes.flatMap { attributes in
            return Dictionary(uniqueKeysWithValues: stride(from: 0, to: attributes.count, by: 2).map {
                (attributes[$0], attributes[$0 + 1])
            })
        } ?? [:]
        
        registry.nodes[id] = self
    }

    public func observe(changed: () -> ()) async {
        for await _ in Observations({
            _ = self.id
            _ = self.type
            _ = self.name
            _ = self.value
            _ = self.childNodeCount
            _ = self.children
            _ = self.attributes
            _ = self.parent
        }) {
            changed()
        }
    }

    public func attributeValue(for name: String) -> String? {
        return attributes[name]
    }
}

@Observable
public final class LightpandaRuntime {
    let url: URL
    var app: Lightpanda?
    private var cdp: CDP!
    var eventTask: Task<(), any Error>?
    var docMessageId = Int?.none
    
    private var nodeRegistry: NodeRegistry = NodeRegistry()
    public nonisolated(unsafe) var dom: Node?
    
    // public init(url: URL) {
    //     self.url = url
    // }

    public init(url: String) {
        self.url = URL(string: url)!
    }
    
    public func start() async {
        redirectStdoutToLogcat()
        print("Starting LightpandaRuntime")

        self.app = Lightpanda()
        self.cdp = app!.makeCDP()
                
        #if DEBUG
        self.cdp!.startDevTools()
        #endif
        
        self.cdp?.eventCallback = { event, data in
            switch event {
            case .documentUpdated:
                let getDocumentMessage = self.cdp!.buildMessage(CDP.DOM.GetDocument(depth: -1, pierce: true))
                print(getDocumentMessage.id)
                self.docMessageId = getDocumentMessage.id
                self.cdp!.sendMessage(getDocumentMessage)
                
                let logMessage = self.cdp!.buildMessage(CDP.Runtime.Evaluate(expression: "console.log(42)"))
                self.cdp!.sendMessage(logMessage)
            case .result(id: self.docMessageId):
                switch try! JSONDecoder().decode(CDP.MethodResult<CDP.DOM.GetDocument>.self, from: data) {
                case let .success(result):
                    print("GOT DOCUMENT")
                    print(result.root)
                    self.dom = Node(from: result.root, registry: self.nodeRegistry)
                    self.docMessageId = nil
                case let .failure(error):
                    fatalError(error.localizedDescription)
                }
            case let .characterDataModified(characterDataModified):
                self.nodeRegistry.nodes[characterDataModified.nodeId]?.value = characterDataModified.characterData
            case let .childNodeInserted(childNodeInserted):
                let newNode = Node(from: childNodeInserted.node, registry: self.nodeRegistry)
                
                let parentNode = self.nodeRegistry.nodes[childNodeInserted.parentNodeId]
                if let sibling = parentNode?.children.firstIndex(where: { $0.id == childNodeInserted.previousNodeId }) {
                    parentNode?.children.insert(newNode, at: sibling + 1)
                } else {
                    parentNode?.children.append(newNode)
                }
            case let .childNodeRemoved(childNodeRemoved):
                
                let parentNode = self.nodeRegistry.nodes[childNodeRemoved.parentNodeId]
                parentNode?.children.removeAll(where: { $0.id == childNodeRemoved.nodeId })
            default:
                break
            }
        }
        
        _ = self.cdp!.createBrowserContext()
        
        self.cdp!.startPageRunLoop()
        
        self.cdp!.sendMessage(self.cdp!.buildMessage(CDP.Log.Enable()))
        self.cdp!.sendMessage(self.cdp!.buildMessage(CDP.Runtime.Enable()))
        self.cdp!.sendMessage(self.cdp!.buildMessage(CDP.Target.SetAutoAttach(autoAttach: true, flatten: true, waitForDebuggerOnStart: true)))
        self.cdp!.sendMessage(self.cdp!.buildMessage(CDP.Page.Navigate(url: self.url.absoluteString)))
        
        print("EXITING START")
    }

    public func observeDOM(changed: () -> ()) async {
        for await _ in Observations({ self.dom }) {
            print(self.dom)
            changed()
        }
    }

    public func callFunctionOn(node: Node, _ function: String) async throws {
        let remoteObject = try await cdp.send(CDP.DOM.ResolveNode(
            nodeId: node.id,
            backendId: nil,
            objectGroup: nil,
            executionContextId: nil
        ))
        cdp.sendMessage(
            cdp.buildMessage(CDP.Runtime.CallFunctionOn(
                functionDeclaration: function,
                objectId: remoteObject.object.objectId!
            ))
        )
    }
}
