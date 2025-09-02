//
//  ContentView.swift
//  StorePriceList
//
//  Created by STUDENT on 8/28/25.
//

import SwiftUI

// MARK: - Models
struct Store: Identifiable {
    let id = UUID()
    let name: String
    let address: String
    let phone: String
    let email: String
    let description: String
    let products: [Product]
}

struct Product: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let price: Double
}

// MARK: - Main View
struct ContentView: View {
    
    @State private var searchText: String = ""
    @State private var showLogin: Bool = false
    @State private var showRegister: Bool = false
    @State private var showDashboard: Bool = false
    
    // Sample Data
    let stores: [Store] = [
        Store(
            name: "John's Store",
            address: "Lucena, 4302",
            phone: "0932032621398",
            email: "john@gmail.com",
            description: "Tindahan",
            products: [
                Product(name: "Bawang", description: "Seasoning", price: 1),
                Product(name: "Sibuyas", description: "Seasoning", price: 2),
                Product(name: "Paminta", description: "Seasoning", price: 3),
                Product(name: "Toyo", description: "Seasoning", price: 4),
                Product(name: "Suka", description: "Pansahog", price: 5),
                Product(name: "UTANG MUNA", description: "SA LUNES BABAYARAN", price: 999)
            ]
        ),
        Store(
            name: "Richard's Store",
            address: "Manila, 1231321",
            phone: "09328931123",
            email: "richard@gmail.com",
            description: "STORE",
            products: [
                Product(name: "Water", description: "Water", price: 123),
                Product(name: "Mineral", description: "Water", price: 456)
            ]
        ),
        Store(
            name: "Oria's Store",
            address: "Canada, 453",
            phone: "092317312",
            email: "orian@gmail.com",
            description: "WAG LAMANAN ANG PRODUCT",
            products: []
        )
    ]
    
    // Search Filtering
    var filteredStores: [Store] {
        if searchText.isEmpty {
            return stores
        } else {
            return stores.filter { store in
                store.name.localizedCaseInsensitiveContains(searchText) ||
                store.description.localizedCaseInsensitiveContains(searchText) ||
                store.products.contains {
                    $0.name.localizedCaseInsensitiveContains(searchText) ||
                    $0.description.localizedCaseInsensitiveContains(searchText)
                }
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                // MARK: Header
                HeaderView(showLogin: $showLogin)
                
                // MARK: Search Bar
                SearchBar(text: $searchText)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                
                // MARK: Scrollable Content
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(filteredStores) { store in
                            StoreCard(store: store)
                        }
                    }
                    .padding()
                }
                .background(Color(.systemGray5).opacity(0.3))
                
                // MARK: Footer
                FooterView()
            }
            .frame(width: 402, height: 874) // iPhone 16 Pro logical size
            .navigationDestination(isPresented: $showLogin) {
                LoginView()
            }
        }
    }
}

// MARK: - Header
struct HeaderView: View {
    @Binding var showLogin: Bool
    
    var body: some View {
        ZStack {
            Color.blue
                .ignoresSafeArea(edges: .top)
            
            HStack {
                // ✅ Login Button
                Button(action: {
                    showLogin = true
                }) {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Text("STORE PRICE LIST")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 5)
                    .lineLimit(1)
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 30)
        }
        .frame(height: 100)
    }
}

// MARK: - SearchBar
struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Search stores or products...", text: $text)
                .foregroundColor(.primary)
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: - StoreCard
struct StoreCard: View {
    let store: Store
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(store.name)
                .font(.title3)
                .fontWeight(.semibold)
            
            Text(store.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Label(store.address, systemImage: "mappin.and.ellipse")
                .font(.footnote)
                .foregroundColor(.gray)
            Label(store.phone, systemImage: "phone.fill")
                .font(.footnote)
                .foregroundColor(.gray)
            Label(store.email, systemImage: "envelope.fill")
                .font(.footnote)
                .foregroundColor(.gray)
            
            Divider()
            
            if store.products.isEmpty {
                Text("No products available")
                    .italic()
                    .foregroundColor(.secondary)
            } else {
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(store.products) { product in
                        HStack {
                            Text(product.name)
                                .fontWeight(.medium)
                            Spacer()
                            Text(product.description)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text("₱\(String(format: "%.2f", product.price))")
                                .fontWeight(.semibold)
                        }
                        Divider()
                    }
                }
                .font(.footnote)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 3)
        )
    }
}

// MARK: - Footer
struct FooterView: View {
    var body: some View {
        VStack(spacing: 12) {
            Divider()
                .padding(.horizontal)

            HStack(spacing: 40) {
                NavigationLink(destination: AboutView()) {
                    Label("About", systemImage: "info.circle")
                        .labelStyle(.titleAndIcon)
                }
                
                NavigationLink(destination: ContactView()) {
                    Label("Contact", systemImage: "envelope")
                        .labelStyle(.titleAndIcon)
                }
                
                NavigationLink(destination: TermsView()) {
                    Label("Terms", systemImage: "doc.plaintext")
                        .labelStyle(.titleAndIcon)
                }
                
                NavigationLink(destination: PrivacyView()) {
                    Label("Privacy", systemImage: "lock.shield")
                        .labelStyle(.titleAndIcon)
                }
            }

            Divider()
                .padding(.horizontal)

            Text("© 2025 Store Price List. All rights reserved.")
                .font(.caption2)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .font(.footnote)
        .padding(.vertical, 16)
        .background(Color(.systemGray6))
        .foregroundColor(.blue)
    }
}


// MARK: - Preview
#Preview {
    ContentView()
}

