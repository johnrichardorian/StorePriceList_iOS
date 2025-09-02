//
//  PrivacyView.swift
//  StorePriceList
//

import SwiftUI

struct PrivacyView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                
                // header content
                ZStack {
                    Circle()
                        .fill(LinearGradient(colors: [.purple, .pink], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 120, height: 120)
                        .shadow(radius: 10)
                    
                    Image(systemName: "lock.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 55, height: 55)
                        .foregroundColor(.white)
                }
                .padding(.top, 30)
                
                // Title
                Text("Privacy Policy")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                // Privacy Cards Content
                VStack(alignment: .leading, spacing: 16) {
                    PrivacyCard(title: "Data Security", description: "All user data is stored securely.")
                    PrivacyCard(title: "No Selling", description: "We do not sell or share your personal data.")
                    PrivacyCard(title: "Data Usage", description: "Data is only used to enhance app functionality.")
                    PrivacyCard(title: "User Rights", description: "Users can request data deletion at any time.")
                }
                .padding(.horizontal)
                
                // Footer content
                VStack(spacing: 8) {
                    Text("Version 1.0.0")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    
                    Text("© 2025 Store Price List. All rights reserved.")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
            }
            .padding()
        }
        .background(
            LinearGradient(colors: [Color(.systemGray6), Color.white], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
        )
        .navigationTitle("Privacy")
        .navigationBarTitleDisplayMode(.inline) // default back button
    }
}

// This is rivacy Card Component
struct PrivacyCard: View {
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.purple.opacity(0.15))
                    .frame(width: 40, height: 40)
                
                Image(systemName: "lock.fill")
                    .foregroundColor(.purple)
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

#Preview {
    NavigationStack {
        PrivacyView()
    }
}
