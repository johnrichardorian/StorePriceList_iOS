//
//  DashboardView.swift
//  StorePriceList
//
//  Created by STUDENT on 8/29/25.
//

import SwiftUI
import SwiftData

struct DashboardView: View {
    @EnvironmentObject var auth: AuthState
    @Environment(\.modelContext) private var modelContext
    @Query private var stores: [StoreEntity]
    @State private var isLoggedOut: Bool = false
    @State private var showLogoutConfirm: Bool = false
    @State private var showIncompleteFormAlert: Bool = false
    @State private var showSavedAlert: Bool = false
    @State private var savedMessage: String = ""
    
    // Store details (bound to first store entity)
    @State private var storeName: String = ""
    @State private var address: String = ""
    @State private var phone: String = ""
    @State private var email: String = ""
    @State private var zip: String = ""
    @State private var description: String = ""
    
    private var isSaveEnabled: Bool {
        // Check if all required fields are filled
        let allFieldsFilled = !storeName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                             !address.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                             !phone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                             !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                             !zip.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                             !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        
        // Check if email is valid
        let emailValid = isValidEmail(email.trimmingCharacters(in: .whitespacesAndNewlines))
        
        // Check if data has changed from saved state
        let dataHasChanged = hasFormDataChanged()
        
        return allFieldsFilled && emailValid && dataHasChanged
    }
    
    private func hasFormDataChanged() -> Bool {
        guard let ownerEmail = auth.currentEmail?.lowercased(),
              let owned = stores.first(where: { $0.ownerEmail?.lowercased() == ownerEmail }) else { return false }
        
        let trimmedName = storeName.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedAddress = address.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPhone = phone.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedZip = zip.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return owned.name != trimmedName ||
               owned.address != trimmedAddress ||
               owned.phone != trimmedPhone ||
               owned.email != trimmedEmail ||
               owned.zip != trimmedZip ||
               owned.storeDescription != trimmedDescription
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let pattern = #"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$"#
        return email.range(of: pattern, options: [.regularExpression, .caseInsensitive]) != nil
    }
    
    private var isStoreDetailsIncomplete: Bool {
        let allFieldsFilled = !storeName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                             !address.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                             !phone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                             !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                             !zip.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                             !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        
        let emailValid = isValidEmail(email.trimmingCharacters(in: .whitespacesAndNewlines))
        
        return !allFieldsFilled || !emailValid
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 0) {
                    
                    // Header
                    HStack {
                        Text("Hello, \(auth.currentName ?? "Guest")")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button(action: {
                            if isStoreDetailsIncomplete {
                                showIncompleteFormAlert = true
                            } else {
                                showLogoutConfirm = true
                            }
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                Text("Logout")
                            }
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.white.opacity(0.2))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 50)
                    .frame(height: 100)
                    .background(Color.blue)
                    
                    
                    // Content
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                                StoreDetailsView(storeName: $storeName,
                                                 address: $address,
                                                 zip: $zip,
                                                 phone: $phone,
                                                 email: $email,
                                                 description: $description,
                                                 isSaveEnabled: isSaveEnabled,
                                                 onSave: {
                                                    guard auth.isLoggedIn else { return }
                                                    let target: StoreEntity?
                                                    if let emailOwner = auth.currentEmail {
                                                        target = stores.first(where: { $0.ownerEmail?.lowercased() == emailOwner.lowercased() })
                                                    } else {
                                                        target = nil
                                                    }
                                                    guard let store = target else { return }
                                                    store.name = storeName
                                                    store.address = address
                                                    store.phone = phone
                                                    store.email = email
                                                    store.zip = zip
                                                    store.storeDescription = description
                                                    try? modelContext.save()
                                                    savedMessage = "Store details saved"
                                                    showSavedAlert = true
                                                 })
                        }
                        .padding()
                    }
                    .background(Color(.systemGray5).opacity(0.3))
                    
                    FooterView()
                }
                .frame(width: 402, height: 874)
                .fullScreenCover(isPresented: $isLoggedOut) {
                    ContentView()
                }
                .alert("Complete Store Details", isPresented: $showIncompleteFormAlert) {
                    Button("Continue Filling Form") { }
                    Button("Logout Anyway", role: .destructive) {
                        auth.logout()
                        isLoggedOut = true
                    }
                } message: {
                    Text("Please complete all required store details before logging out. You can save your progress and return later.")
                }
                .alert("Confirm Logout", isPresented: $showLogoutConfirm) {
                    Button("Cancel", role: .cancel) { }
                    Button("Logout", role: .destructive) {
                        auth.logout()
                        isLoggedOut = true
                    }
                } message: {
                    Text("Are you sure you want to logout?")
                }
                .alert(savedMessage, isPresented: $showSavedAlert) {
                    Button("OK", role: .cancel) { }
                }
                
            }
        }
        .onAppear { ensureOwnedStoreAndBind() }
    }
}


// Store Details View
struct StoreDetailsView: View {
    @Binding var storeName: String
    @Binding var address: String
    @Binding var zip: String
    @Binding var phone: String
    @Binding var email: String
    @Binding var description: String
    var isSaveEnabled: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Store Details")
                .font(.title3)
                .fontWeight(.semibold)
            
            Group {
                field("Store Name", text: $storeName, isRequired: true)
                field("Address", text: $address, isRequired: true)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Zip Code *")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    TextField("Enter zip code", text: $zip)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: zip) { oldValue, newValue in
                            let digits = newValue.filter { $0.isNumber }
                            if digits != newValue { zip = digits }
                        }
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text("Phone *")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    TextField("Enter phone", text: $phone)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: phone) { oldValue, newValue in
                            let digits = newValue.filter { $0.isNumber }
                            if digits != newValue { phone = digits }
                        }
                }
                field("Email", text: $email, isRequired: true)
                field("Description", text: $description, isRequired: true)
            }
            
            
            Button("Save") { onSave() }
            .frame(maxWidth: .infinity)
            .padding()
            .background(isSaveEnabled ? Color.blue : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(12)
            .padding(.top, 10)
            .disabled(!isSaveEnabled)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 16).fill(Color.white).shadow(radius: 4))
    }
    
    func field(_ title: String, text: Binding<String>, isRequired: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(isRequired ? "\(title) *" : title)
                .font(.subheadline)
                .foregroundColor(.gray)
            TextField("Enter \(title.lowercased())", text: text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
        }
    }
    var onSave: () -> Void = {}
}




#Preview { DashboardView() }

extension DashboardView {
    func ensureOwnedStoreAndBind() {
        guard let emailOwner = auth.currentEmail?.lowercased() else { return }
        if stores.first(where: { $0.ownerEmail?.lowercased() == emailOwner }) == nil {
            let emptyStore = StoreEntity(name: "", address: "", phone: "", email: emailOwner, zip: "", storeDescription: "", ownerEmail: emailOwner)
            modelContext.insert(emptyStore)
            try? modelContext.save()
        }
        bindFromStore()
    }
    func bindFromStore() {
        let userEmailLowercased = auth.currentEmail?.lowercased()
        guard let ownerEmail = userEmailLowercased, let owned = stores.first(where: { $0.ownerEmail?.lowercased() == ownerEmail }) else {
            storeName = ""
            address = ""
            phone = ""
            email = ""
            zip = ""
            description = ""
            return
        }
        storeName = owned.name
        address = owned.address
        phone = owned.phone
        email = owned.email
        zip = owned.zip
        description = owned.storeDescription
    }
    func reloadFromStore() { bindFromStore() }
    func currentOwnedStore() -> StoreEntity? {
        guard let emailOwner = auth.currentEmail?.lowercased() else { return nil }
        return stores.first(where: { $0.ownerEmail?.lowercased() == emailOwner })
    }
}
