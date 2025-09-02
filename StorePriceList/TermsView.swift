//
//  TermsView.swift
//  StorePriceList
//


import SwiftUI

struct TermsView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                
                // Header Icon
                ZStack {
                    Circle()
                        .fill(LinearGradient(colors: [.orange, .red], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 120, height: 120)
                        .shadow(radius: 10)
                    
                    Image(systemName: "doc.plaintext.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 55, height: 55)
                        .foregroundColor(.white)
                }
                .padding(.top, 30)
                
                // Title
                Text("Terms & Conditions")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                // Terms Cards
                VStack(alignment: .leading, spacing: 16) {
                    TermsCard(title: "Responsibility", description: "You are responsible for the accuracy of store and product information.")
                    TermsCard(title: "Information Purpose", description: "This app is for informational purposes only.")
                    TermsCard(title: "Liability", description: "We are not liable for any loss or damages resulting from use of the app.")
                    TermsCard(title: "Copyright", description: "Respect all copyright and intellectual property laws.")
                }
                .padding(.horizontal)
                
                // Footer
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
        .navigationTitle("Terms")
        .navigationBarTitleDisplayMode(.inline) // default back button
    }
}

// Terms Card Component
struct TermsCard: View {
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.orange.opacity(0.15))
                    .frame(width: 40, height: 40)
                
                Image(systemName: "doc.plaintext.fill")
                    .foregroundColor(.orange)
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
        TermsView()
    }
}
