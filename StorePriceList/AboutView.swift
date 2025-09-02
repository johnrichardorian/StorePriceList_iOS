//
//  AboutView.swift
//  StorePriceList
//
//  Created by STUDENT on 8/29/25.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                
                // MARK: App Icon / Logo
                ZStack {
                    Circle()
                        .fill(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 120, height: 120)
                        .shadow(radius: 10)
                    
                    Image(systemName: "cart.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 55, height: 55)
                        .foregroundColor(.white)
                }
                .padding(.top, 30)
                
                // MARK: Title & Subtitle
                VStack(spacing: 8) {
                    Text("Store Price List")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("Your Smart Store Companion")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                
                // MARK: App Description
                VStack(alignment: .leading, spacing: 16) {
                    AboutCard(
                        icon: "magnifyingglass",
                        title: "Search Products",
                        description: "Quickly find stores or products using the built-in search feature."
                    )
                    AboutCard(
                        icon: "cart.badge.plus",
                        title: "Manage Inventory",
                        description: "Easily view product lists, prices, and details in one place."
                    )
                    AboutCard(
                        icon: "person.crop.circle",
                        title: "User Friendly",
                        description: "Simple, modern design with easy navigation for everyone."
                    )
                }
                .padding(.horizontal)
                
                // MARK: Footer
                VStack(spacing: 8) {
                    Text("Version 1.0.0")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    
                    Text("© 2025 Store Price List. All rights reserved.")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 20)
                
                Spacer()
            }
            .padding()
        }
        .background(
            LinearGradient(colors: [Color(.systemGray6), Color.white], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
        )
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline) // Default back button will appear automatically
    }
}

// MARK: - About Card Component
struct AboutCard: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.15))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .foregroundColor(.blue)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 3)
        )
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        AboutView()
    }
}
