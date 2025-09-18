extension CDP {
    public struct Emulation {
        // Methods
        
        public struct SetEmulatedMedia: CDP.Method {
            public static let method = "Emulation.setEmulatedMedia"
            
            public let features: [Feature]
            
            public let media: String
            
            public struct Feature: Encodable, Sendable {
                public let name: String
                public let value: String
            }
            
            public struct Response: Decodable, Sendable {}
        }
        
        public struct SetFocusEmulationEnabled: CDP.Method {
            public static let method = "Emulation.setFocusEmulationEnabled"
            
            public let enabled: Bool
            
            public struct Response: Decodable, Sendable {}
        }
    }
}
