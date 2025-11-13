extension CDP {
    struct Emulation {
        // Methods
        
        struct SetEmulatedMedia: CDP.Method {
            static let method = "Emulation.setEmulatedMedia"
            
            let features: [Feature]
            
            let media: String
            
            struct Feature: Encodable, Sendable {
                let name: String
                let value: String
            }
            
            struct Response: Decodable, Sendable {}
        }
        
        struct SetFocusEmulationEnabled: CDP.Method {
            static let method = "Emulation.setFocusEmulationEnabled"
            
            let enabled: Bool
            
            struct Response: Decodable, Sendable {}
        }
    }
}
