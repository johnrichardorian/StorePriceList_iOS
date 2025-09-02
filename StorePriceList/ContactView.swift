//
//  ContactView.swift
//  StorePriceList
//

import SwiftUI

struct ContactView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                
                // header area
                ZStack {
                    Circle()
                        .fill(LinearGradient(colors: [.green, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 120, height: 120)
                        .shadow(radius: 10)
                    
                    Image(systemName: "envelope.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 55, height: 55)
                        .foregroundColor(.white)
                }
                .padding(.top, 30)
                
                // title content
                VStack(spacing: 8) {
                    Text("Contact Us")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("We are here to help")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                
                // contact cards content
                VStack(spacing: 16) {
                    ContactCard(icon: "phone.fill", title: "Phone", description: "0932 032 61398")
                    ContactCard(icon: "envelope.fill", title: "Email", description: "support@storepricelist.com")
                    ContactCard(icon: "globe", title: "Website", description: "www.storepricelist.com")
                    ContactCard(icon: "location.fill", title: "Address", description: "Lucena City, Philippines")
                }
                .padding(.horizontal)
                
                // about footer
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
        .navigationTitle("Contact")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Contact Card Component
struct ContactCard: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.15))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .foregroundColor(.green)
                    .font(.system(size: 22))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
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
        ContactView()
    }
}

