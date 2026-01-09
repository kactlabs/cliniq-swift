import Foundation

/// Mock authentication service for development and testing
/// Simulates real authentication behavior without external dependencies
class MockAuthService: AuthServiceProtocol {
    /// In-memory storage for registered users during app session
    private var registeredUsers: [String: (password: String, user: User)] = [:]
    
    /// Predefined test users for development and testing
    private let predefinedUsers: [String: String] = [
        "test@cliniq.com": "password123",
        "demo@cliniq.com": "demo123"
    ]
    
    /// Simulated network delay range in seconds
    private let minDelay: Double = 0.5
    private let maxDelay: Double = 1.5
    
    init() {
        // Pre-populate registered users with predefined test accounts
        for (email, password) in predefinedUsers {
            let user = User(email: email)
            registeredUsers[email.lowercased()] = (password: password, user: user)
        }
    }
    
    /// Authenticate a user with email and password
    /// - Parameters:
    ///   - email: User's email address
    ///   - password: User's password
    /// - Returns: Authenticated User object
    /// - Throws: ValidationError.invalidCredentials if authentication fails
    func authenticate(email: String, password: String) async throws -> User {
        // Simulate realistic network delay
        try await simulateNetworkDelay()
        
        let normalizedEmail = email.lowercased().trimmingCharacters(in: .whitespaces)
        
        // Check if user exists and password matches
        guard let userData = registeredUsers[normalizedEmail],
              userData.password == password else {
            throw ValidationError.invalidCredentials
        }
        
        return userData.user
    }
    
    /// Create a new user account
    /// - Parameters:
    ///   - email: User's email address
    ///   - password: User's password
    /// - Returns: Newly created User object
    /// - Throws: ValidationError if account creation fails
    func createAccount(email: String, password: String) async throws -> User {
        // Simulate realistic network delay
        try await simulateNetworkDelay()
        
        let normalizedEmail = email.lowercased().trimmingCharacters(in: .whitespaces)
        
        // Check if user already exists
        if registeredUsers[normalizedEmail] != nil {
            throw ValidationError.userExists
        }
        
        // Create new user
        let newUser = User(email: normalizedEmail)
        registeredUsers[normalizedEmail] = (password: password, user: newUser)
        
        return newUser
    }
    
    /// Simulate network delay for realistic authentication experience
    private func simulateNetworkDelay() async throws {
        let delay = Double.random(in: minDelay...maxDelay)
        try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
    }
}
