extension CDP {
    struct Target {
        // Methods
        
        struct CreateTarget: CDP.Method {
            static let method = "Target.createTarget"
            
            let url: String
            let browserContextId: String?
            
            struct Response: Decodable, Sendable {
                let targetId: String
            }
        }
        
        struct CreateBrowserContext: CDP.Method {
            static let method = "Target.createBrowserContext"
            
            struct Response: Decodable, Sendable {
                let browserContextId: String
            }
        }
        
        struct SetAutoAttach: CDP.Method {
            static let method = "Target.setAutoAttach"
            
            let autoAttach: Bool
            let flatten: Bool
            let waitForDebuggerOnStart: Bool
            
            struct Response: Decodable, Sendable {}
        }
        
        struct SetDiscoverTargets: CDP.Method {
            static let method = "Target.setDiscoverTargets"
            
            let discover: Bool
            
            struct Response: Decodable, Sendable {}
        }
        
        // Events
        
        struct TargetCreated: Decodable, Sendable {
            let targetInfo: TargetInfo
        }
        
        // Types
        
        struct TargetInfo: Decodable, Sendable {
            let url: String
            let title: String
            let targetId: String
            let attached: Bool
            let type: String
            let canAccessOpener: Bool
            let browserContextId: String
        }
    }
}
