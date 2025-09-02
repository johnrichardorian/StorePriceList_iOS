//
//  PrivacyView.swift
//  StorePriceList
//

import SwiftUI

struct PrivacyView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 30) { // match AboutView spacing
                
                // MARK: Header Icon
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
                .padding(.top, 30) // same as AboutView
                
                // MARK: Title
                Text("Privacy Policy")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                // MARK: Privacy Cards
                VStack(alignment: .leading, spacing: 16) { // consistent spacing
                    PrivacyCard(title: "Data Security", description: "All user data is stored securely.")
                    PrivacyCard(title: "No Selling", description: "We do not sell or share your personal data.")
                    PrivacyCard(title: "Data Usage", description: "Data is only used to enhance app functionality.")
                    PrivacyCard(title: "User Rights", description: "Users can request data deletion at any time.")
                }
                .padding(.horizontal)
                
                // MARK: Footer
                VStack(spacing: 8) { // match AboutView footer spacing
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
            .padding() // match AboutView padding
        }
        .background(
            LinearGradient(colors: [Color(.systemGray6), Color.white], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
        )
        .navigationTitle("Privacy")
        .navigationBarTitleDisplayMode(.inline) // default back button
    }
}

// MARK: - Privacy Card Component
struct PrivacyCard: View {
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) { // same as AboutCard
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

// MARK: - Preview
#Preview {
    NavigationStack {
        PrivacyView()
    }
}
