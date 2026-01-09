import Foundation

/// Protocol defining the authentication service interface
/// Supports both login and registration operations with async/await
protocol AuthServiceProtocol {
    /// Authenticate a user with email and password
    /// - Parameters:
    ///   - email: User's email address
    ///   - password: User's password
    /// - Returns: Authenticated User object
    /// - Throws: ValidationError if authentication fails
    func authenticate(email: String, password: String) async throws -> User
    
    /// Create a new user account
    /// - Parameters:
    ///   - email: User's email address
    ///   - password: User's password
    /// - Returns: Newly created User object
    /// - Throws: ValidationError if account creation fails
    func createAccount(email: String, password: String) async throws -> User
}
