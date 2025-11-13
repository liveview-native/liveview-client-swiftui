extension CDP {
    struct CSS {
        // Methods
        
        struct Enable: CDP.Method {
            static let method = "CSS.enable"
            
            struct Response: Decodable, Sendable {}
        }
    }
}
