//
//  ContentView.swift
//  StorePriceList
//
//  Created by STUDENT on 8/28/25.
//

import SwiftUI
import SwiftData

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
    @EnvironmentObject var auth: AuthState
    @Query(sort: \StoreEntity.name, order: .forward) private var storeEntities: [StoreEntity]
    @State private var searchText: String = ""
    @State private var showLogin: Bool = false
    @State private var showRegister: Bool = false
    @State private var showDashboard: Bool = false
    var stores: [Store] {
        storeEntities.map { se in
            Store(
                name: se.name,
                address: "\(se.address), \(se.zip)",
                phone: se.phone,
                email: se.email,
                description: se.storeDescription,
                products: se.products.map { Product(name: $0.name, description: $0.productDescription, price: $0.price) }
            )
        }
    }
    var filteredStores: [Store] {
        let filtered = if searchText.isEmpty { 
            stores 
        } else {
            stores.filter { store in
                store.name.localizedCaseInsensitiveContains(searchText) ||
                store.description.localizedCaseInsensitiveContains(searchText) ||
                store.products.contains {
                    $0.name.localizedCaseInsensitiveContains(searchText) ||
                    $0.description.localizedCaseInsensitiveContains(searchText)
                }
            }
        }
        return filtered.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
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
                            StoreCard(store: store, searchText: searchText)
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
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: - HighlightedText
struct HighlightedText: View {
    let text: String
    let searchText: String
    let highlightColor: Color
    let textColor: Color
    
    init(text: String, searchText: String, highlightColor: Color = .orange, textColor: Color = .white) {
        self.text = text
        self.searchText = searchText
        self.highlightColor = highlightColor
        self.textColor = textColor
    }
    
    var body: some View {
        if searchText.isEmpty {
            Text(text)
        } else {
            let highlightedText = highlightText(text, searchText: searchText)
            highlightedText
        }
    }
    
    @ViewBuilder
    private func highlightText(_ text: String, searchText: String) -> some View {
        let lowercaseText = text.lowercased()
        let lowercaseSearch = searchText.lowercased()
        
        if let range = lowercaseText.range(of: lowercaseSearch) {
            let beforeMatch = String(text[..<range.lowerBound])
            let match = String(text[range])
            let afterMatch = String(text[range.upperBound...])
            
            HStack(spacing: 0) {
                Text(beforeMatch)
                Text(match)
                    .foregroundColor(textColor)
                    .background(highlightColor)
                    .fontWeight(.bold)
                Text(afterMatch)
            }
        } else {
            Text(text)
        }
    }
}

// MARK: - StoreCard
struct StoreCard: View {
    let store: Store
    let searchText: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HighlightedText(text: store.name, searchText: searchText, highlightColor: .blue, textColor: .white)
                .font(.title3)
                .fontWeight(.semibold)
            
            HighlightedText(text: store.description, searchText: searchText, highlightColor: .green, textColor: .white)
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
                            HighlightedText(text: product.name, searchText: searchText, highlightColor: .orange, textColor: .white)
                                .fontWeight(.medium)
                            Spacer()
                            HighlightedText(text: product.description, searchText: searchText, highlightColor: .purple, textColor: .white)
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

