//
//  DashboardView.swift
//  StorePriceList
//
//  Created by STUDENT on 8/29/25.
//

import SwiftUI

struct DashboardView: View {
    
    @State private var selectedTab = 0
    @State private var isLoggedOut: Bool = false
    
    // Store details sample data
    @State private var storeName: String = "John's Store"
    @State private var address: String = "Lucena"
    @State private var phone: String = "0932032621398"
    @State private var email: String = "john@gmail.com"
    @State private var zip: String = "4302"
    @State private var description: String = "Tindahan"
    
    // Search text
    @State private var searchText: String = ""
    
    // Products sample data
    @State private var products: [InventoryProduct] = [
        InventoryProduct(name: "Bawang", description: "Seasoning", price: 1),
        InventoryProduct(name: "Sibuyas", description: "Seasoning", price: 2),
        InventoryProduct(name: "Toyo", description: "Pang sahog", price: 4)
    ]
    
    // Modals controller show
    @State private var showCreateForm = false
    @State private var showEditForm = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 0) {
                    
                    // Header
                    HStack {
                        Text("Hello, John Richard Orian")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button(action: {
                            isLoggedOut = true
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
                    
                    // Content
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            if selectedTab == 0 {
                                StoreDetailsView(storeName: $storeName,
                                                 address: $address,
                                                 zip: $zip,
                                                 phone: $phone,
                                                 email: $email,
                                                 description: $description)
                            } else {
                                InventoryView(searchText: $searchText,
                                              products: $products,
                                              showCreateForm: $showCreateForm,
                                              showEditForm: $showEditForm)
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
                
                // This is modal for add product
                if showCreateForm {
                    ZStack {
                        
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()
                            .background(.ultraThinMaterial)
                            .onTapGesture {
                                showCreateForm = false // tap outside to close
                            }
                        
                        ProductFormView(
                            title: "Add Product",
                            name: "",
                            description: "",
                            price: ""
                        ) {
                            showCreateForm = false
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
                
                // modal for edit product
                if showEditForm, let first = products.first {
                    ZStack {
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()
                            .background(.ultraThinMaterial)
                            .onTapGesture {
                                showEditForm = false
                            }
                        
                        ProductFormView(
                            title: "Edit Product",
                            name: first.name,
                            description: first.description,
                            price: String(first.price)
                        ) {
                            showEditForm = false
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
    }
}

// Product model
struct InventoryProduct: Identifiable {
    let id = UUID()
    var name: String
    var description: String
    var price: Double
}

// Store Details View
struct StoreDetailsView: View {
    @Binding var storeName: String
    @Binding var address: String
    @Binding var zip: String
    @Binding var phone: String
    @Binding var email: String
    @Binding var description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Store Details")
                .font(.title3)
                .fontWeight(.semibold)
            
            Group {
                field("Store Name", text: $storeName)
                field("Address", text: $address)
                field("Zip Code", text: $zip)
                field("Phone", text: $phone)
                field("Email", text: $email)
                field("Description", text: $description)
            }
            
            Button("Save") {
                print("✅ Store saved")
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(12)
            .padding(.top, 10)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 16).fill(Color.white).shadow(radius: 4))
    }
    
    func field(_ title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
            TextField("Enter \(title.lowercased())", text: text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}

// Inventory View
struct InventoryView: View {
    @Binding var searchText: String
    @Binding var products: [InventoryProduct]
    @Binding var showCreateForm: Bool
    @Binding var showEditForm: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Products")
                    .font(.title3)
                    .fontWeight(.semibold)
                Spacer()
                Button(action: {
                    showCreateForm = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add")
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            
            TextField("Search products...", text: $searchText)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
            
            let filteredProducts = products.filter { product in
                searchText.isEmpty ||
                product.name.localizedCaseInsensitiveContains(searchText) ||
                product.description.localizedCaseInsensitiveContains(searchText)
            }
            
            if filteredProducts.isEmpty {
                Text("No products found")
                    .foregroundColor(.secondary)
            } else {
                ForEach(filteredProducts) { product in
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
                                    if product.id == products.first?.id {
                                        showEditForm = true
                                    }
                                }) {
                                    Image(systemName: "pencil.circle.fill")
                                        .foregroundColor(.blue)
                                        .font(.title3)
                                }
                                Button(action: {
                                    print("🗑️ Delete \(product.name)")
                                }) {
                                    Image(systemName: "trash.circle.fill")
                                        .foregroundColor(.red)
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
    var onCancel: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
            
            Group {
                field("Product Name", text: $name)
                field("Description", text: $description)
                field("Price", text: $price)
            }
            
            HStack {
                Button("Cancel") {
                    onCancel()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.gray.opacity(0.3))
                .foregroundColor(.black)
                .cornerRadius(12)
                
                Button("Save") {
                    print("✅ \(title) saved")
                    onCancel()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .padding(.top, 10)
        }
        .padding()
    }
    
    func field(_ title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
            TextField("Enter \(title.lowercased())", text: text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}

#Preview {
    DashboardView()
}
