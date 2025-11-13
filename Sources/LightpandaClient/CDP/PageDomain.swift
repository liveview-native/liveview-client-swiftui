extension CDP {
    struct Page {
        // Methods
        
        struct Enable: CDP.Method {
            static let method = "Page.enable"
            
            struct Response: Decodable, Sendable {}
        }
        
        struct Navigate: CDP.Method {
            static let method = "Page.navigate"
            
            let url: String
            
            struct Response: Decodable, Sendable {
                let frameId: String
            }
        }
        
        struct SetLifecycleEventsEnabled: CDP.Method {
            static let method = "Page.setLifecycleEventsEnabled"
            
            let enabled: Bool
            
            struct Response: Decodable, Sendable {}
        }
    }
}
