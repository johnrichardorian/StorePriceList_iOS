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
    @State private var selectedTab = 0
    @State private var isLoggedOut: Bool = false
    @State private var showLogoutConfirm: Bool = false
    @State private var showIncompleteFormAlert: Bool = false
    @State private var showSavedAlert: Bool = false
    @State private var savedMessage: String = ""
    @State private var showDeleteConfirm: Bool = false
    @State private var pendingDelete: InventoryProduct? = nil
    
    // Store details (bound to first store entity)
    @State private var storeName: String = ""
    @State private var address: String = ""
    @State private var phone: String = ""
    @State private var email: String = ""
    @State private var zip: String = ""
    @State private var description: String = ""
    
    // Products (from SwiftData)
    @State private var products: [InventoryProduct] = []
    @State private var productSearchText: String = ""
    
    // Modals
    @State private var showCreateForm = false
    @State private var showEditForm = false
    @State private var productBeingEdited: InventoryProduct? = nil
    
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
    
    private var canAccessInventory: Bool {
        // Must be complete AND saved (no unsaved changes)
        return !isStoreDetailsIncomplete && !hasFormDataChanged()
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
                    
                    // Tab
                    Picker("", selection: $selectedTab) {
                        Text("Store Details").tag(0)
                        Text("Inventory").tag(1)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .onChange(of: selectedTab) { oldValue, newValue in
                        if newValue == 1 && !canAccessInventory {
                            selectedTab = 0
                        }
                    }
                    
                    // Content
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            if selectedTab == 0 {
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
                            } else {
                                InventoryView(searchText: $productSearchText,
                                              products: $products,
                                              showCreateForm: $showCreateForm,
                                              showEditForm: $showEditForm,
                                              isReadOnly: !auth.isLoggedIn,
                                              onDelete: { item in
                                                pendingDelete = item
                                                showDeleteConfirm = true
                                              },
                                              onEdit: { item in
                                                productBeingEdited = item
                                                showEditForm = true
                                              })
                            }
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
                
                // Overlay for Add Product
                if showCreateForm {
                    ZStack {
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()
                            .background(.ultraThinMaterial)
                            .onTapGesture {
                                showCreateForm = false
                            }
                        
                        ProductFormView(
                            title: "Add Product",
                            name: "",
                            description: "",
                            price: "",
                            existingNames: existingProductNames(),
                            excludeName: nil
                        ) {
                            showCreateForm = false
                        } onSave: { name, description, price in
                            guard auth.isLoggedIn else { return }
                            let target: StoreEntity?
                            if let emailOwner = auth.currentEmail {
                                target = stores.first(where: { $0.ownerEmail?.lowercased() == emailOwner.lowercased() })
                            } else {
                                target = nil
                            }
                            guard let store = target else { return }
                            let p = ProductEntity(name: name, productDescription: description, price: price)
                            store.products.append(p)
                            try? modelContext.save()
                            reloadFromStore()
                            savedMessage = "Product added"
                            showSavedAlert = true
                        }
                        .frame(maxWidth: 350)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white)
                                .shadow(radius: 10)
                        )
                        .padding()
                    }
                    .transition(.opacity.combined(with: .scale))
                    .animation(.spring(), value: showCreateForm)
                }
                
                // Overlay for Edit Product
                if showEditForm, let editing = productBeingEdited {
                    ZStack {
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()
                            .background(.ultraThinMaterial)
                            .onTapGesture {
                                showEditForm = false
                                productBeingEdited = nil
                            }
                        
                        ProductFormView(
                            title: "Edit Product",
                            name: editing.name,
                            description: editing.description,
                            price: String(editing.price),
                            existingNames: existingProductNames(),
                            excludeName: editing.name
                        ) {
                            showEditForm = false
                            productBeingEdited = nil
                        } onSave: { name, description, price in
                            guard auth.isLoggedIn else { return }
                            let target: StoreEntity?
                            if let emailOwner = auth.currentEmail {
                                target = stores.first(where: { $0.ownerEmail?.lowercased() == emailOwner.lowercased() })
                            } else {
                                target = nil
                            }
                            guard let store = target, let original = productBeingEdited else { return }
                            if let idx = store.products.firstIndex(where: { $0.name == original.name && $0.productDescription == original.description && $0.price == original.price }) {
                                store.products[idx].name = name
                                store.products[idx].productDescription = description
                                store.products[idx].price = price
                                try? modelContext.save()
                                reloadFromStore()
                                savedMessage = "Product updated"
                                showSavedAlert = true
                            }
                        }
                        .frame(maxWidth: 350)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white)
                                .shadow(radius: 10)
                        )
                        .padding()
                    }
                    .transition(.opacity.combined(with: .scale))
                    .animation(.spring(), value: showEditForm)
                }
                
            }
        }
        .onAppear { ensureOwnedStoreAndBind() }
        .alert("Delete Product?", isPresented: $showDeleteConfirm) {
            Button("Cancel", role: .cancel) { pendingDelete = nil }
            Button("Delete", role: .destructive) {
                guard auth.isLoggedIn, let item = pendingDelete else { pendingDelete = nil; return }
                let target: StoreEntity?
                if let emailOwner = auth.currentEmail {
                    target = stores.first(where: { $0.ownerEmail?.lowercased() == emailOwner.lowercased() })
                } else {
                    target = nil
                }
                guard let store = target else { pendingDelete = nil; return }
                if let idx = store.products.firstIndex(where: { $0.name == item.name && $0.productDescription == item.description && $0.price == item.price }) {
                    let entity = store.products[idx]
                    modelContext.delete(entity)
                    try? modelContext.save()
                    reloadFromStore()
                }
                pendingDelete = nil
            }
        } message: {
            Text("This action cannot be undone.")
        }
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

// Product model
struct InventoryProduct: Identifiable {
    let id = UUID()
    var name: String
    var description: String
    var price: Double
}

// Inventory View
struct InventoryView: View {
    @Binding var searchText: String
    @Binding var products: [InventoryProduct]
    @Binding var showCreateForm: Bool
    @Binding var showEditForm: Bool
    var isReadOnly: Bool = false
    var onDelete: (InventoryProduct) -> Void = { _ in }
    var onEdit: (InventoryProduct) -> Void = { _ in }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Products")
                    .font(.title3)
                    .fontWeight(.semibold)
                Spacer()
                Button(action: {
                    if !isReadOnly { showCreateForm = true }
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add")
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(isReadOnly ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            TextField("Search products...", text: $searchText)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
            
            let filtered = products.filter { p in
                searchText.isEmpty ||
                p.name.localizedCaseInsensitiveContains(searchText) ||
                p.description.localizedCaseInsensitiveContains(searchText)
            }
            if filtered.isEmpty {
                Text("No products found")
                    .foregroundColor(.secondary)
            } else {
                ForEach(filtered) { product in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(product.name)
                                    .fontWeight(.semibold)
                                Text(product.description)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Text("₱\(String(format: "%.2f", product.price))")
                                .fontWeight(.bold)
                            HStack(spacing: 10) {
                                Button(action: {
                                    if !isReadOnly { onEdit(product) }
                                }) {
                                    Image(systemName: "pencil.circle.fill")
                                        .foregroundColor(isReadOnly ? .gray : .blue)
                                        .font(.title3)
                                }
                                Button(action: {
                                    if !isReadOnly { onDelete(product) }
                                }) {
                                    Image(systemName: "trash.circle.fill")
                                        .foregroundColor(isReadOnly ? .gray : .red)
                                        .font(.title3)
                                }
                            }
                        }
                    }
                    .padding(.vertical, 8)
                    Divider()
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 16).fill(Color.white).shadow(radius: 4))
    }
}

// Product Form View (compact floating modal)
struct ProductFormView: View {
    var title: String
    @State var name: String
    @State var description: String
    @State var price: String
    var existingNames: [String] = []
    var excludeName: String? = nil
    var onCancel: () -> Void
    var onSave: (String, String, Double) -> Void = { _,_,_  in }
    
    @State private var validationError: String = ""
    
    private var nameError: String? {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedName.isEmpty { return "Name is required" }
        let lower = trimmedName.lowercased()
        if let exclude = excludeName?.lowercased(), lower == exclude { return nil }
        if existingNames.contains(lower) { return "Product name already exists" }
        return nil
    }
    private var descriptionError: String? {
        let trimmed = description.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty { return "Description is required" }
        return nil
    }
    private var priceError: String? {
        guard !price.isEmpty else { return "Price is required" }
        if Double(price) == nil { return "Price must be a number" }
        if let p = Double(price), p < 0 { return "Price cannot be negative" }
        return nil
    }
    private var isValid: Bool {
        return nameError == nil && descriptionError == nil && priceError == nil
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Product Name")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                TextField("Enter product name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Description")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                TextField("Enter description", text: $description)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Price")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                TextField("Enter price", text: $price)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .onChange(of: price) { oldValue, newValue in
                        let filtered = newValue.filter { "0123456789.".contains($0) }
                        var result = ""
                        var dotSeen = false
                        for ch in filtered {
                            if ch == "." {
                                if dotSeen { continue }
                                dotSeen = true
                            }
                            result.append(ch)
                        }
                        if result != newValue { price = result }
                    }
            }
            
            HStack {
                Button(action: { onCancel() }) {
                    Text("Cancel")
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .contentShape(Rectangle())
                }
                .background(Color.gray.opacity(0.3))
                .foregroundColor(.black)
                .cornerRadius(12)
                
                Button(action: {
                    if isValid, let p = Double(price) {
                        onSave(name.trimmingCharacters(in: .whitespacesAndNewlines), description, p)
                        onCancel()
                    } else {
                        validationError = nameError ?? descriptionError ?? priceError ?? "Please fix errors"
                    }
                }) {
                    Text("Save")
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .contentShape(Rectangle())
                }
                .background(isValid ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(12)
                .disabled(!isValid)
            }
            .padding(.top, 10)
        }
        .padding()
        .alert("Invalid Product", isPresented: Binding(get: { !validationError.isEmpty }, set: { if !$0 { validationError = "" } })) {
            Button("OK", role: .cancel) { validationError = "" }
        } message: {
            Text(validationError)
        }
    }
}




#Preview { DashboardView() }

extension DashboardView {
    func ensureOwnedStoreAndBind() {
        guard let emailOwner = auth.currentEmail?.lowercased() else { return }
        if stores.first(where: { $0.ownerEmail?.lowercased() == emailOwner }) == nil {
            let emptyStore = StoreEntity(name: "", address: "", phone: "", email: emailOwner, zip: "", storeDescription: "", products: [], ownerEmail: emailOwner)
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
            products = []
            return
        }
        storeName = owned.name
        address = owned.address
        phone = owned.phone
        email = owned.email
        zip = owned.zip
        description = owned.storeDescription
        products = owned.products.map { InventoryProduct(name: $0.name, description: $0.productDescription, price: $0.price) }
    }
    func reloadFromStore() { bindFromStore() }
    func currentOwnedStore() -> StoreEntity? {
        guard let emailOwner = auth.currentEmail?.lowercased() else { return nil }
        return stores.first(where: { $0.ownerEmail?.lowercased() == emailOwner })
    }
    func existingProductNames() -> [String] {
        currentOwnedStore()?.products.map { $0.name.lowercased() } ?? []
    }
}
