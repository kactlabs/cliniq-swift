# Design Document: User Authentication

## Overview

The user authentication system for ClinIQ will provide a complete login and registration flow using SwiftUI for the iOS application. The system will use a mock authentication service to simulate real authentication behavior without external dependencies, making it ideal for development and testing.

The authentication flow follows a standard pattern: unauthenticated users see the login screen, can create accounts or sign in, and upon successful authentication are taken to the main app interface. The system maintains session state during app usage but requires re-authentication when the app is relaunched.

## Architecture

The authentication system follows the MVVM (Model-View-ViewModel) pattern common in SwiftUI applications:

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Views         │    │   ViewModels     │    │   Services      │
│                 │    │                  │    │                 │
│ • LoginView     │◄──►│ • AuthViewModel  │◄──►│ • MockAuthService│
│ • RegisterView  │    │                  │    │ • UserSession   │
│ • ContentView   │    │                  │    │                 │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

**Key Components:**
- **Views**: SwiftUI views for login, registration, and main content
- **AuthViewModel**: Observable object managing authentication state and user interactions
- **MockAuthService**: Service layer providing authentication operations
- **UserSession**: Model representing the current user's authenticated state

## Components and Interfaces

### AuthViewModel
```swift
@MainActor
class AuthViewModel: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var currentUser: User? = nil
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    func login(email: String, password: String) async
    func register(email: String, password: String, confirmPassword: String) async
    func logout()
}
```

### MockAuthService
```swift
protocol AuthServiceProtocol {
    func authenticate(email: String, password: String) async throws -> User
    func createAccount(email: String, password: String) async throws -> User
}

class MockAuthService: AuthServiceProtocol {
    private var registeredUsers: [String: User] = [:]
    private let predefinedUsers: [String: String] = [
        "test@cliniq.com": "password123",
        "demo@cliniq.com": "demo123"
    ]
}
```

### User Model
```swift
struct User: Identifiable, Codable {
    let id: UUID
    let email: String
    let createdAt: Date
}
```

### Views Structure
- **ContentView**: Root view that decides between authentication and main app
- **AuthenticationView**: Container for login/register flow
- **LoginView**: Email/password input with login button
- **RegisterView**: Email/password/confirm password with registration

## Data Models

### User
The User model represents an authenticated user in the system:
- `id`: Unique identifier (UUID)
- `email`: User's email address (used as username)
- `createdAt`: Account creation timestamp

### AuthenticationState
Enum representing the current authentication state:
- `unauthenticated`: No user logged in
- `authenticating`: Login/register in progress
- `authenticated(User)`: User successfully logged in

### ValidationError
Enum for form validation errors:
- `invalidEmail`: Email format is incorrect
- `weakPassword`: Password doesn't meet requirements
- `passwordMismatch`: Password confirmation doesn't match
- `userExists`: Email already registered
- `invalidCredentials`: Login credentials are incorrect

## Error Handling

The system handles errors at multiple levels:

1. **Input Validation**: Client-side validation for email format, password strength
2. **Service Errors**: Authentication failures, network simulation delays
3. **UI Feedback**: Clear error messages displayed to users
4. **State Recovery**: Graceful handling of authentication state transitions

Error messages are user-friendly and provide actionable guidance:
- "Please enter a valid email address"
- "Password must be at least 8 characters"
- "Passwords do not match"
- "Invalid email or password"

## Correctness Properties

*A property is a characteristic or behavior that should hold true across all valid executions of a system-essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees.*

### Property 1: Valid credentials always authenticate successfully
*For any* valid email and password combination, authentication should succeed and establish a user session
**Validates: Requirements 1.2**

### Property 2: Invalid credentials always fail authentication
*For any* invalid email and password combination, authentication should fail and display an error message while remaining on the login view
**Validates: Requirements 1.3**

### Property 3: Successful authentication navigates to main interface
*For any* successful authentication, the system should navigate away from the login view to the main app interface
**Validates: Requirements 1.4**

### Property 4: Valid registration data creates accounts successfully
*For any* valid registration data (email, password, matching confirmation), account creation should succeed and establish a user session
**Validates: Requirements 2.2**

### Property 5: Invalid registration data shows validation errors
*For any* invalid registration data, the system should display appropriate validation errors and prevent account creation
**Validates: Requirements 2.3**

### Property 6: Email validation follows standard format rules
*For any* email input, validation should correctly identify valid and invalid email formats according to standard email format rules
**Validates: Requirements 2.5**

### Property 7: Authentication operations have consistent timing
*For any* authentication operation (login or register), the system should provide consistent response timing and loading feedback
**Validates: Requirements 3.2**

### Property 8: User registration persists in session
*For any* successfully registered user, the user data should be stored and retrievable during the current app session
**Validates: Requirements 3.3**

### Property 9: Invalid service requests return appropriate errors
*For any* invalid authentication request to the mock service, appropriate error responses should be returned
**Validates: Requirements 3.4**

### Property 10: Form submission shows loading feedback
*For any* form submission (login or register), visual loading feedback should be displayed during processing
**Validates: Requirements 4.4**

### Property 11: Authentication session persists during app usage
*For any* successfully authenticated user, the session should remain active throughout normal app usage
**Validates: Requirements 5.1**

### Property 12: Background/foreground preserves authentication
*For any* authenticated session, backgrounding and resuming the app should preserve the authenticated state
**Validates: Requirements 5.2**

### Property 13: Logout clears session completely
*For any* authenticated user, logout should completely clear the user session and return to unauthenticated state
**Validates: Requirements 5.3**

### Property 14: App restart requires re-authentication
*For any* previously authenticated session, terminating and relaunching the app should require fresh authentication
**Validates: Requirements 5.4**

## Testing Strategy

The authentication system will use a dual testing approach:

### Unit Tests
- Test individual components (AuthViewModel, MockAuthService)
- Validate form input validation logic
- Test error handling scenarios
- Verify state transitions
- Test specific examples like predefined credentials and UI element presence

### Property-Based Tests
- Test authentication flows across various input combinations
- Validate that successful authentication always results in authenticated state
- Ensure error conditions are handled consistently
- Test session management properties
- Verify universal behaviors across all valid inputs

**Testing Framework**: XCTest with Swift Testing for property-based tests
**Test Configuration**: Minimum 100 iterations per property test
**Test Organization**: Tests co-located with source files using standard Xcode structure

Both unit tests and property tests are complementary and necessary for comprehensive coverage. Unit tests catch concrete bugs and verify specific examples, while property tests verify general correctness across all inputs.