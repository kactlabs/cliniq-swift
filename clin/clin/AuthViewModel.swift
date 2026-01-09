import Foundation
import SwiftUI
import Combine

/// ViewModel managing authentication state and user interactions
/// Follows MVVM pattern for SwiftUI authentication flow
class AuthViewModel: ObservableObject {
    // MARK: - Published Properties (Task 3.1)
    
    /// Whether the user is currently authenticated
    @Published var isAuthenticated: Bool = false
    
    /// The currently authenticated user, if any
    @Published var currentUser: User? = nil
    
    /// Whether an authentication operation is in progress
    @Published var isLoading: Bool = false
    
    /// Error message to display to the user
    @Published var errorMessage: String? = nil
    
    // MARK: - Dependencies
    
    /// Authentication service for login and registration
    private let authService: AuthServiceProtocol
    
    // MARK: - Initialization
    
    /// Initialize with an authentication service
    /// - Parameter authService: Service conforming to AuthServiceProtocol
    init(authService: AuthServiceProtocol = MockAuthService()) {
        self.authService = authService
    }
    
    // MARK: - Login (Task 3.2)
    
    /// Authenticate user with email and password
    /// - Parameters:
    ///   - email: User's email address
    ///   - password: User's password
    @MainActor
    func login(email: String, password: String) async {
        // Clear any previous error
        errorMessage = nil
        
        // Validate inputs
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = ValidationError.emptyField("Email").localizedDescription
            return
        }
        
        guard !password.isEmpty else {
            errorMessage = ValidationError.emptyField("Password").localizedDescription
            return
        }
        
        // Set loading state
        isLoading = true
        
        do {
            let user = try await authService.authenticate(email: email, password: password)
            
            // Update state on success
            currentUser = user
            isAuthenticated = true
            errorMessage = nil
        } catch let error as ValidationError {
            // Handle validation errors with user-friendly messages
            errorMessage = error.localizedDescription
            isAuthenticated = false
            currentUser = nil
        } catch {
            // Handle unexpected errors
            errorMessage = "An unexpected error occurred. Please try again."
            isAuthenticated = false
            currentUser = nil
        }
        
        // Clear loading state
        isLoading = false
    }
    
    // MARK: - Registration (Task 3.3)
    
    /// Register a new user account
    /// - Parameters:
    ///   - email: User's email address
    ///   - password: User's password
    ///   - confirmPassword: Password confirmation for validation
    @MainActor
    func register(email: String, password: String, confirmPassword: String) async {
        // Clear any previous error
        errorMessage = nil
        
        // Validate inputs
        let trimmedEmail = email.trimmingCharacters(in: .whitespaces)
        
        guard !trimmedEmail.isEmpty else {
            errorMessage = ValidationError.emptyField("Email").localizedDescription
            return
        }
        
        // Validate email format
        guard isValidEmail(trimmedEmail) else {
            errorMessage = ValidationError.invalidEmail.localizedDescription
            return
        }
        
        guard !password.isEmpty else {
            errorMessage = ValidationError.emptyField("Password").localizedDescription
            return
        }
        
        // Validate password strength (minimum 8 characters)
        guard password.count >= 8 else {
            errorMessage = ValidationError.weakPassword.localizedDescription
            return
        }
        
        // Validate password confirmation matches
        guard password == confirmPassword else {
            errorMessage = ValidationError.passwordMismatch.localizedDescription
            return
        }
        
        // Set loading state
        isLoading = true
        
        do {
            let user = try await authService.createAccount(email: trimmedEmail, password: password)
            
            // Update state on success
            currentUser = user
            isAuthenticated = true
            errorMessage = nil
        } catch let error as ValidationError {
            // Handle validation errors with user-friendly messages
            errorMessage = error.localizedDescription
            isAuthenticated = false
            currentUser = nil
        } catch {
            // Handle unexpected errors
            errorMessage = "An unexpected error occurred. Please try again."
            isAuthenticated = false
            currentUser = nil
        }
        
        // Clear loading state
        isLoading = false
    }
    
    // MARK: - Logout (Task 3.4)
    
    /// Log out the current user and clear session
    @MainActor
    func logout() {
        currentUser = nil
        isAuthenticated = false
        errorMessage = nil
        isLoading = false
    }
    
    // MARK: - Validation Helpers
    
    /// Validate email format using standard regex pattern
    /// - Parameter email: Email string to validate
    /// - Returns: True if email format is valid
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    /// Clear the current error message
    @MainActor
    func clearError() {
        errorMessage = nil
    }
}
