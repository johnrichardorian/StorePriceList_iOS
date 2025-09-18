//
//  RegisterView.swift
//  StorePriceList
//
//  Created by STUDENT on 8/28/25.
//

import SwiftUI
import SwiftData

struct RegisterView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var accounts: [Account]
    @EnvironmentObject var auth: AuthState
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var isConfirmPasswordVisible: Bool = false
    @State private var didRegister: Bool = false
    @State private var showError: Bool = false
    @State private var showSuccess: Bool = false
    @State private var errorMessage: String = ""
    func isValidEmail(_ email: String) -> Bool {
        let pattern = #"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$"#
        return email.range(of: pattern, options: [.regularExpression, .caseInsensitive]) != nil
    }
    
    var body: some View {
        VStack {
            Spacer().frame(height: 40)
            
            Image(systemName: "person.badge.plus.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 70, height: 70)
                .foregroundColor(.green)
                .padding(.bottom, 10)
            
            Text("Create Your Account")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 5)
            
            Text("Register to access Store Price List")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.bottom, 30)
            
            VStack(alignment: .leading, spacing: 6) {
                TextField("Full Name", text: $name)
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled(true)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 6) {
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    if isPasswordVisible {
                        TextField("Password", text: $password)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                    } else {
                        SecureField("Password", text: $password)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                    }
                    Button(action: { isPasswordVisible.toggle() }) {
                        Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            }
            .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    if isConfirmPasswordVisible {
                        TextField("Confirm Password", text: $confirmPassword)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                    } else {
                        SecureField("Confirm Password", text: $confirmPassword)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                    }
                    Button(action: { isConfirmPasswordVisible.toggle() }) {
                        Image(systemName: isConfirmPasswordVisible ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            }
            .padding(.horizontal)
            
            Button(action: {
                let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
                let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !trimmedName.isEmpty else {
                    errorMessage = "Enter your full name"
                    showError = true
                    return
                }
                guard isValidEmail(trimmedEmail) else {
                    errorMessage = "Enter a valid email address"
                    showError = true
                    return
                }
                guard password.count >= 6 else {
                    errorMessage = "Password must be at least 6 characters"
                    showError = true
                    return
                }
                guard password == confirmPassword else {
                    errorMessage = "Passwords do not match"
                    showError = true
                    return
                }
                guard accounts.first(where: { $0.email.lowercased() == trimmedEmail.lowercased() }) == nil else {
                    errorMessage = "Email already registered"
                    showError = true
                    return
                }
                let newEmail = trimmedEmail.lowercased()
                let newName = trimmedName
                let account = Account(email: newEmail, name: newName, password: password)
                modelContext.insert(account)
                try? modelContext.save()
                
                auth.login(email: newEmail, name: newName)
                
                name = ""
                email = ""
                password = ""
                confirmPassword = ""
                
                showSuccess = true
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
            .navigationDestination(isPresented: $didRegister) { DashboardView() }
            .alert("Registration Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
            .alert("Account Created Successfully!", isPresented: $showSuccess) {
                Button("Continue to Dashboard") {
                    didRegister = true
                }
            } message: {
                Text("Let's set up your store details.")
            }
            
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
            
            HStack {
                Text("Already have an account?")
                NavigationLink("Login") {
                    LoginView()
                }
                .foregroundColor(.blue)
            }
            .padding(.top, 20)
            
            Spacer()
            
            Text("Your data is safe with Store Price List")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.bottom, 20)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    RegisterView()
}
