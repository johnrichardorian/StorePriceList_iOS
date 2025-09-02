//
//  RegisterView.swift
//  StorePriceList
//
//  Created by STUDENT on 8/28/25.
//

import SwiftUI

struct RegisterView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var isConfirmPasswordVisible: Bool = false
    
    var body: some View {
        VStack {
            Spacer().frame(height: 40) // Safe area / Dynamic island
            
            // 🛒 Logo / Icon
            Image(systemName: "person.badge.plus.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 70, height: 70)
                .foregroundColor(.green)
                .padding(.bottom, 10)
            
            // Title
            Text("Create Your Account")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 5)
            
            // Subtitle
            Text("Register to access Store Price List")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.bottom, 30)
            
            // Name
            TextField("Full Name", text: $name)
                .textInputAutocapitalization(.words)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
            
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
                Button(action: { isPasswordVisible.toggle() }) {
                    Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)
            
            // Confirm Password
            HStack {
                if isConfirmPasswordVisible {
                    TextField("Confirm Password", text: $confirmPassword)
                } else {
                    SecureField("Confirm Password", text: $confirmPassword)
                }
                Button(action: { isConfirmPasswordVisible.toggle() }) {
                    Image(systemName: isConfirmPasswordVisible ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)
            
            // Register Button
            Button(action: {
                // Handle register logic here
            }) {
                Text("Register")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .padding(.top, 20)
            
            
            
            // OR Divider
            HStack {
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray.opacity(0.3))
                Text("OR")
                    .foregroundColor(.gray)
                    .font(.subheadline)
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray.opacity(0.3))
            }
            .padding(.vertical, 15)
            .padding(.horizontal)
            
            // Continue as Guest
            NavigationLink(destination: ContentView()) {
                HStack {
                    Image(systemName: "person.fill")
                        .foregroundColor(.blue)
                    Text("Continue as Guest")
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue, lineWidth: 1)
                )
                .cornerRadius(10)
                .padding(.horizontal)
            }
            .padding(.top, 10)
            
            // Already have account? Login
            HStack {
                Text("Already have an account?")
                NavigationLink("Login") {
                    LoginView()
                }
                .foregroundColor(.blue)
            }
            .padding(.top, 20)
            
            Spacer()
            
            // Small footer
            Text("Your data is safe with Store Price List")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.bottom, 20)
        }
        .navigationBarBackButtonHidden(true) // hides default back button
    }
}

#Preview {
    RegisterView()
}
