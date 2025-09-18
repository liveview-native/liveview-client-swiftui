import lightpanda
import Foundation

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
            Unmanaged<CDP>.fromOpaque(ctx!).takeUnretainedValue().handleMessage(message)
        }, Unmanaged.passUnretained(cdp).toOpaque())
        return cdp
    }
}

@Observable
@MainActor
public final class Demo {
    var app: Lightpanda?
    var cdp: CDP?
    var eventTask: Task<(), any Error>?
    var docMessageId = Int?.none
    
    public var dom: CDP.DOM.Node?
    
    public init() {}
    
    public func start() async throws {
        self.app = Lightpanda()
        self.cdp = app!.makeCDP()
        
        self.cdp?.eventCallback = { event, data in
            switch event {
            case .documentUpdated:
                let getDocumentMessage = self.cdp!.buildMessage(CDP.DOM.GetDocument(depth: -1, pierce: true))
                print(getDocumentMessage.id)
                self.docMessageId = getDocumentMessage.id
                self.cdp!.sendMessage(getDocumentMessage)
            case .result(id: self.docMessageId):
                switch try! JSONDecoder().decode(CDP.MethodResult<CDP.DOM.GetDocument>.self, from: data) {
                case let .success(result):
                    print("GOT DOCUMENT")
                    print(result.root)
                    self.dom = result.root
                case let .failure(error):
                    fatalError(error.localizedDescription)
                }
            default:
                break
            }
        }
        
        _ = self.cdp!.createBrowserContext()
        
        self.cdp!.startPageRunLoop()
        
        self.cdp!.sendMessage(self.cdp!.buildMessage(CDP.Network.Enable(maxPostDataSize: 65536, reportDirectSocketTraffic: true)))
        self.cdp!.sendMessage(self.cdp!.buildMessage(CDP.Runtime.Enable()))
        self.cdp!.sendMessage(self.cdp!.buildMessage(CDP.Target.SetAutoAttach(autoAttach: true, flatten: true, waitForDebuggerOnStart: true)))
        self.cdp!.sendMessage(self.cdp!.buildMessage(CDP.Page.Navigate(url: "http://localhost:4000")))
        
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
