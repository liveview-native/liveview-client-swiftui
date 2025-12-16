import lightpanda
import Foundation
import SwiftUI

@MainActor
public final class Lightpanda {
    var address: UnsafeMutableRawPointer!
    
    public init() {
        self.address = lightpanda_app_init()
    }
    
    @MainActor
    deinit {
        lightpanda_app_deinit(address)
    }
    
    public func makeBrowser() -> Browser {
        return Browser(address: lightpanda_browser_init(self.address))
    }
    
    public func makeCDP() -> CDP {
        let cdp = CDP()
        cdp.address = lightpanda_cdp_init(self.address, { [] ctx, message in
            // handle message
            Unmanaged<CDP>.fromOpaque(ctx!).takeUnretainedValue().handleMessage(message)
        }, { [] ctx, nodeId in
            // focus node
            withAnimation(.snappy) {
                Unmanaged<CDP>.fromOpaque(ctx!).takeUnretainedValue().focusedNode = Node.ID(nodeId)
            }
        }, { [] ctx, message in
            // paused in debugger message
            // NOTE: this doesn't work because the pause loop blocks the main thread
            withAnimation(.snappy) {
                Unmanaged<CDP>.fromOpaque(ctx!).takeUnretainedValue().pausedInDebuggerMessage = message.flatMap(String.init(cString:))
            }
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
    
    @MainActor
    @discardableResult
    public func callFunction(
        runtime: LightpandaRuntime,
        function: String
    ) async throws -> CDP.Runtime.CallFunctionOn.Response {
        let remoteObject = try await runtime.cdp.send(CDP.DOM.ResolveNode(
            nodeId: self.id,
            backendId: nil,
            objectGroup: nil,
            executionContextId: nil
        ))
        return try await runtime.cdp.send(CDP.Runtime.CallFunctionOn(
            functionDeclaration: function,
            objectId: remoteObject.object.objectId!
        ))
    }
}

@Observable
@MainActor
public final class LightpandaRuntime {
    let url: URL
    var app: Lightpanda?
    public var cdp: CDP!
    var eventTask: Task<(), any Error>?
    var docMessageId = Int?.none
    
    public var nodeRegistry: NodeRegistry = NodeRegistry()
    public var dom: Node?
    
    public init(url: URL) {
        self.url = url
    }
    
    @MainActor
    public func start() async throws {
        self.app = Lightpanda()
        self.cdp = app!.makeCDP()
                
        #if DEBUG
        self.cdp!.startDevTools()
        #endif
        
        self.cdp?.eventCallback = { event, data in
            switch event {
            case .documentUpdated:
                print("=== document updated ===")
                let getDocumentMessage = self.cdp!.buildMessage(CDP.DOM.GetDocument(depth: -1, pierce: true))
                print(getDocumentMessage.id)
                self.docMessageId = getDocumentMessage.id
                self.cdp!.sendMessage(getDocumentMessage)
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
            case let .attributeModified(attributeModified):
                self.nodeRegistry.nodes[attributeModified.nodeId]?.attributes[attributeModified.name] = attributeModified.value
            case let .attributeRemoved(attributedRemoved):
                self.nodeRegistry.nodes[attributedRemoved.nodeId]?.attributes.removeValue(forKey: attributedRemoved.name)
            case let .bindingCalled(bindingCalled):
                self.cdp.bindingCalled(bindingCalled)
            default:
                break
            }
        }
        
        _ = self.cdp!.createBrowserContext()
        
        self.cdp!.startPageRunLoop()
        
//        self.cdp!.sendMessage(self.cdp!.buildMessage(CDP.Network.Enable(maxPostDataSize: 65536, reportDirectSocketTraffic: true)))
        self.cdp!.sendMessage(self.cdp!.buildMessage(CDP.Log.Enable()))
        self.cdp!.sendMessage(self.cdp!.buildMessage(CDP.Runtime.Enable()))
        self.cdp!.sendMessage(self.cdp!.buildMessage(CDP.Target.SetAutoAttach(autoAttach: true, flatten: true, waitForDebuggerOnStart: false)))
        self.cdp!.sendMessage(self.cdp!.buildMessage(CDP.Page.Navigate(url: self.url.absoluteString)))
        
//        self.cdp?.eventCallback = { event in
////            print("RECEIVED EVENT:", event)
//            switch event {
//            case .documentUpdated:
//                print("GOT DOM")
//                try! await self.cdp!.processMessage(CDP.DOM.GetDocument(depth: -1, pierce: true))
//            default:
//                break
//            }
//        }
//        
//        _ = self.cdp!.createBrowserContext()
//        
//        self.cdp?.startPageRunLoop()
//        
//        _ = try await self.cdp!.processMessage(CDP.Network.Enable(maxPostDataSize: 65536, reportDirectSocketTraffic: true))
//        
//        _ = try await self.cdp!.processMessage(CDP.Page.Enable())
//        
//        _ = try await self.cdp!.processMessage(CDP.Runtime.Enable())
//        
//        _ = try await self.cdp!.processMessage(CDP.DOM.Enable())
//        _ = try await self.cdp!.processMessage(CDP.CSS.Enable())
//        _ = try await self.cdp!.processMessage(CDP.Log.Enable())
//        _ = try await self.cdp!.processMessage(CDP.Emulation.SetEmulatedMedia(
//            features: [
//                .init(name: "color-gamut", value: ""),
//                .init(name: "prefers-color-scheme", value: ""),
//                .init(name: "forced-colors", value: ""),
//                .init(name: "prefers-contrast", value: ""),
//                .init(name: "prefers-reduced-data", value: ""),
//                .init(name: "prefers-reduced-motion", value: ""),
//                .init(name: "prefers-reduced-transparency", value: ""),
//            ],
//            media: ""
//        ))
//        
//        _ = try await self.cdp!.processMessage(CDP.Inspector.Enable())
//        
//        _ = try await self.cdp!.processMessage(CDP.Target.SetAutoAttach(autoAttach: true, flatten: true, waitForDebuggerOnStart: true))
//        
//        _ = try await self.cdp!.processMessage(CDP.Target.SetDiscoverTargets(discover: true))
//        
//        _ = try await self.cdp!.processMessage(CDP.Runtime.AddBinding(name: "__chromium_devtools_metrics_reporter", executionContextName: "DevTools Performance Metrics"))
//        
//        _ = try await self.cdp!.processMessage(CDP.Runtime.RunIfWaitingForDebugger())
//        
//        _ = try await self.cdp!.processMessage(CDP.Emulation.SetFocusEmulationEnabled(enabled: true))
//        
////        _ = try await self.cdp!.processMessage(CDP.Page.Navigate(url: "http://localhost:4000"))
//        _ = try await self.cdp!.processMessage(CDP.Page.Navigate(url: "http://localhost:4000"))
        
//        print("EXITING START")
    }
}
