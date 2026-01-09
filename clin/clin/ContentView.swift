//
//  ContentView.swift
//  clin
//
//  Created by Vipranan on 10/01/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @State private var showGetStarted: Bool = false
    
    var body: some View {
        ZStack {
            if !showGetStarted {
                // Show splash/welcome screen with Get Started button
                SplashView(showGetStarted: $showGetStarted)
                    .transition(.opacity)
            } else if authViewModel.isAuthenticated {
                // Main app content after authentication
                MainAppView(viewModel: authViewModel)
                    .transition(.opacity)
            } else {
                // Show authentication flow
                AuthenticationView(viewModel: authViewModel)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.4), value: showGetStarted)
        .animation(.easeInOut(duration: 0.3), value: authViewModel.isAuthenticated)
    }
}

/// Main app view shown after successful authentication
struct MainAppView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    // Brand colors
    private let primaryTeal = Color(red: 0.2, green: 0.6, blue: 0.5)
    private let lightTeal = Color(red: 0.4, green: 0.75, blue: 0.65)
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer()
                
                // Welcome message
                VStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(primaryTeal)
                    
                    Text("Welcome to ClinIQ!")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(primaryTeal)
                    
                    if let user = viewModel.currentUser {
                        Text(user.email)
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                // Logout button
                Button(action: {
                    viewModel.logout()
                }) {
                    Text("Sign Out")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(primaryTeal)
                        )
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    ContentView()
}
