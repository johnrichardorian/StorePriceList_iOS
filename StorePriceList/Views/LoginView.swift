//
//  LoginView.swift
//  StorePriceList
//
//  Created by STUDENT on 8/28/25.
//

import SwiftUI
import SwiftData

struct LoginView: View {
    @EnvironmentObject var auth: AuthState
    @Environment(\.modelContext) private var modelContext
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var rememberMe: Bool = false
    @State private var isLoggedIn: Bool = false
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    func isValidEmail(_ email: String) -> Bool {
        let pattern = #"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$"#
        return email.range(of: pattern, options: [.regularExpression, .caseInsensitive]) != nil
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                
                Spacer().frame(height: 20)
                
                Image(systemName: "cart.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 70)
                    .foregroundColor(.blue)
                    .padding(.bottom, 10)
                
                Text("Welcome to Store Price List")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 5)
                
                Text("Login to manage and view prices")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 30)
                
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
                }
                .padding(.horizontal)
                
                Toggle("Remember Me", isOn: $rememberMe)
                    .padding(.horizontal)
                    .padding(.top, 10)
                    .onChange(of: rememberMe) { oldValue, newValue in
                        UserDefaults.standard.set(newValue, forKey: "rememberMeEnabled")
                        if !newValue {
                            auth.clearRememberedSession()
                        }
                    }
                
                Button(action: {
                    let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !trimmedEmail.isEmpty, !password.isEmpty else {
                        errorMessage = "Please enter email and password"
                        showError = true
                        return
                    }
                    guard isValidEmail(trimmedEmail) else {
                        errorMessage = "Enter a valid email address"
                        showError = true
                        return
                    }
                    let normalized = trimmedEmail.lowercased()
                    var descriptor = FetchDescriptor<Account>(predicate: #Predicate { $0.email == normalized })
                    descriptor.fetchLimit = 1
                    do {
                        let results = try modelContext.fetch(descriptor)
                        guard let acc = results.first else {
                            errorMessage = "Account not found"
                            showError = true
                            return
                        }
                        guard acc.password == password else {
                            errorMessage = "Incorrect password"
                            showError = true
                            return
                        }
                        auth.login(email: acc.email, name: acc.name)
                        if rememberMe {
                            auth.rememberSession(email: acc.email, name: acc.name, password: password)
                        } else {
                            auth.clearRememberedSession()
                        }
                        isLoggedIn = true
                    } catch {
                        errorMessage = "Failed to fetch account"
                        showError = true
                    }
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
                .alert("Login Error", isPresented: $showError) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text(errorMessage)
                }
                
                HStack {
                    Text("Don’t have an account?")
                    NavigationLink("Register") { RegisterView() }
                    .foregroundColor(.blue)
                }
                .padding(.top, 20)
                
                HStack {
                    Rectangle().frame(height: 1).foregroundColor(.gray.opacity(0.4))
                    Text("OR")
                        .foregroundColor(.gray)
                        .font(.caption)
                    Rectangle().frame(height: 1).foregroundColor(.gray.opacity(0.4))
                }
                .padding(.horizontal)
                .padding(.top, 25)
                
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
                
                Text("Secure access to Store Price List")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.bottom, 20)
            }
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $isLoggedIn) {
                DashboardView()
            }
        }
        .onAppear {
            if auth.isLoggedIn, let e = auth.currentEmail {
                email = e
            } else {
                let defaults = UserDefaults.standard
                rememberMe = defaults.bool(forKey: "rememberMeEnabled")
                if rememberMe, let savedEmail = defaults.string(forKey: "rememberEmail") {
                    email = savedEmail
                    if let pwd = auth.savedPasswordForRememberedEmail() {
                        password = pwd
                    }
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
 
