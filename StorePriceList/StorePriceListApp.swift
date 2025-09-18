//
//  StorePriceListApp.swift
//  StorePriceList
//
//  Created by STUDENT on 8/28/25.
//

import SwiftUI
import SwiftData

@main
struct StorePriceListApp: App {
    @StateObject private var auth = AuthState()
    var body: some Scene {
        WindowGroup {
            Group {
                if auth.isLoggedIn {
                    DashboardView()
                } else {
                    ContentView()
                }
            }
            .environmentObject(auth)
            .onAppear {
                auth.restoreIfRemembered()
            }
        }
        .modelContainer(sharedModelContainer)
    }
}

#if DEBUG
private let previewContainer: ModelContainer = {
    let schema = Schema([
        Account.self,
        StoreEntity.self,
        ProductEntity.self
    ])
    let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: schema, configurations: [configuration])
    let context = ModelContext(container)

    //DEMO DATA for testing purposes only
    
    let demo1 = Account(email: "john@gmail.com", name: "John Cena", password: "john123")
    let demo2 = Account(email: "richard@gmail.com", name: "Richard Santos", password: "richard123")
    let demo3 = Account(email: "orian@gmail.com", name: "Orian Dela Cruz", password: "orian123")
    let demo4 = Account(email: "shanel@gmail.com", name: "Shanel Garcia", password: "shanel123")
    
    context.insert(demo1)
    context.insert(demo2)
    context.insert(demo3)
    context.insert(demo4)
    
    // John's Store (ingredients)
    let p1 = ProductEntity(name: "Garlic", productDescription: "Seasoning", price: 1)
    let p2 = ProductEntity(name: "Onion", productDescription: "Seasoning", price: 23)
    let p3 = ProductEntity(name: "Soy Sauce", productDescription: "Pang sahog", price: 4)
    let p4 = ProductEntity(name: "Rice", productDescription: "Staple", price: 55)
    let p5 = ProductEntity(name: "Sugar", productDescription: "Sweetener", price: 70)
    let p6 = ProductEntity(name: "Oil", productDescription: "Pantry", price: 120)
    let p7 = ProductEntity(name: "Salt", productDescription: "Pantry", price: 15)
    let p8 = ProductEntity(name: "Vinegar", productDescription: "Pantry", price: 25)
    let p9 = ProductEntity(name: "Pepper", productDescription: "Seasoning", price: 10)
    let store1 = StoreEntity(name: "John's Store", address: "Lucena", phone: "0932032621398", email: "john@gmail.com", zip: "4302", storeDescription: "Sari-Sari Store", products: [p1, p2, p3, p4, p5, p6, p7, p8, p9], ownerEmail: "john@gmail.com")
    
    // Richard's Market (ingredients)
    let r1 = ProductEntity(name: "Garlic", productDescription: "Seasoning", price: 334)
    let r2 = ProductEntity(name: "Onion", productDescription: "Seasoning", price: 23)
    let r3 = ProductEntity(name: "Soy Sauce", productDescription: "Pang sahog", price: 34)
    let r4 = ProductEntity(name: "Rice", productDescription: "Staple", price: 56)
    let r5 = ProductEntity(name: "Sugar", productDescription: "Sweetener", price: 68)
    let r6 = ProductEntity(name: "Oil", productDescription: "Pantry", price: 118)
    let r7 = ProductEntity(name: "Salt", productDescription: "Pantry", price: 14)
    let r8 = ProductEntity(name: "Vinegar", productDescription: "Pantry", price: 24)
    let r9 = ProductEntity(name: "Flour", productDescription: "Baking", price: 45)
    let store2 = StoreEntity(name: "Richard's Market", address: "Quezon City", phone: "09123456789", email: "richard@gmail.com", zip: "1100", storeDescription: "Fresh market", products: [r1, r2, r3, r4, r5, r6, r7, r8, r9], ownerEmail: "richard@gmail.com")
    
    // Orian's Bakery (ingredients)
    let o1 = ProductEntity(name: "Flour", productDescription: "Baking", price: 453)
    let o2 = ProductEntity(name: "Sugar", productDescription: "Sweetener", price: 69)
    let o3 = ProductEntity(name: "Eggs", productDescription: "Protein", price: 83)
    let o4 = ProductEntity(name: "Butter", productDescription: "Dairy", price: 85)
    let o5 = ProductEntity(name: "Yeast", productDescription: "Baking", price: 15)
    let o6 = ProductEntity(name: "Milk", productDescription: "Dairy", price: 60)
    let o7 = ProductEntity(name: "Baking Powder", productDescription: "Baking", price: 20)
    let o8 = ProductEntity(name: "Salt", productDescription: "Pantry", price: 153)
    let o9 = ProductEntity(name: "Oil", productDescription: "Pantry", price: 118)
    let store3 = StoreEntity(name: "Orian's Bakery", address: "Makati", phone: "09234567890", email: "orian@gmail.com", zip: "1200", storeDescription: "Bakery and dairy", products: [o1, o2, o3, o4, o5, o6, o7, o8, o9], ownerEmail: "orian@gmail.com")
    
    // Shanel's Market (ingredients/produce)
    let s1 = ProductEntity(name: "Tomatoes", productDescription: "Produce", price: 3655)
    let s2 = ProductEntity(name: "Garlic", productDescription: "Seasoning", price: 1150)
    let s3 = ProductEntity(name: "Onion", productDescription: "Seasoning", price: 265)
    let s4 = ProductEntity(name: "Ginger", productDescription: "Seasoning", price: 3045)
    let s5 = ProductEntity(name: "Chili", productDescription: "Seasoning", price: 512)
    let s6 = ProductEntity(name: "Lemongrass", productDescription: "Herb", price: 121)
    let s7 = ProductEntity(name: "Salt", productDescription: "Pantry", price: 1521)
    let s8 = ProductEntity(name: "Cilantro", productDescription: "Herb", price: 2013)
    let s9 = ProductEntity(name: "Potatoes", productDescription: "Produce", price: 4230)
    let store4 = StoreEntity(name: "Shanel's Fruits", address: "Manila", phone: "09345678901", email: "shanel@gmail.com", zip: "1000", storeDescription: "Fresh fruits", products: [s1, s2, s3, s4, s5, s6, s7, s8, s9], ownerEmail: "shanel@gmail.com")
    
    context.insert(store1)
    context.insert(store2)
    context.insert(store3)
    context.insert(store4)
    try? context.save()

    return container
}()

#Preview("App Preview") {
    ContentView()
        .environmentObject(AuthState())
        .modelContainer(previewContainer)
}
#endif

private var sharedModelContainer: ModelContainer = {
    let schema = Schema([
        Account.self,
        StoreEntity.self,
        ProductEntity.self
    ])
    let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
    do {
        let container = try ModelContainer(for: schema, configurations: [configuration])
        try seedIfNeeded(container: container)
        return container
    } catch {
        fatalError("Unresolved error: \(error)")
    }
}()

private func seedIfNeeded(container: ModelContainer) throws {
    // No seed data needed - users will create their own accounts and stores
    // Demo data is available in preview container for testing purposes only
}
