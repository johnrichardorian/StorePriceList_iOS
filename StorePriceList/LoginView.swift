//
//  LoginView.swift
//  StorePriceList
//
//  Created by STUDENT on 8/28/25.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var rememberMe: Bool = false
    @State private var isLoggedIn: Bool = false   // track login state
    
    var body: some View {
        NavigationStack {
            VStack {
                
                Spacer().frame(height: 20) // Safe area / Dynamic island
                
                // Store Logo / Icon
                Image(systemName: "cart.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 70)
                    .foregroundColor(.blue)
                    .padding(.bottom, 10)
                
                // App Title
                Text("Welcome to Store Price List")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 5)
                
                // Subtitle hint
                Text("Login to manage and view prices")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 30)
                
                // Email
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                // Password
                HStack {
                    if isPasswordVisible {
                        TextField("Password", text: $password)
                    } else {
                        SecureField("Password", text: $password)
                    }
                    Button(action: {
                        isPasswordVisible.toggle()
                    }) {
                        Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                
                // Remember Me toggle
                Toggle("Remember Me", isOn: $rememberMe)
                    .padding(.horizontal)
                    .padding(.top, 10)
                
                // Login Button
                Button(action: {
                    // For now it always allow login for sample
                    // add validation here later
                    isLoggedIn = true
                }) {
                    Text("Login")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .padding(.top, 20)
                
                // Register link
                HStack {
                    Text("Don’t have an account?")
                    NavigationLink("Register") {
                        RegisterView()
                    }
                    .foregroundColor(.blue)
                }
                .padding(.top, 20)
                
                // Divider for login and guest button
                HStack {
                    Rectangle().frame(height: 1).foregroundColor(.gray.opacity(0.4))
                    Text("OR")
                        .foregroundColor(.gray)
                        .font(.caption)
                    Rectangle().frame(height: 1).foregroundColor(.gray.opacity(0.4))
                }
                .padding(.horizontal)
                .padding(.top, 25)
                
                // Continue as Guest
                NavigationLink(destination: ContentView()) {
                    Text("Continue as Guest")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 1)
                        )
                        .foregroundColor(.blue)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .padding(.top, 10)
                
                Spacer()
                
                // Small footer
                Text("Secure access to Store Price List")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.bottom, 20)
            }
            .navigationBarBackButtonHidden(true) // hides default back button
            
            .navigationDestination(isPresented: $isLoggedIn) {
                //DashboardView()
            }
        }
    }
}

#Preview {
    LoginView()
}
 
