extension CDP {
    public struct Log {
        // Methods
        
        public struct Enable: CDP.Method {
            public static let method = "Log.enable"
            
            public struct Response: Decodable, Sendable {}
        }
    }
}
