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
        StoreEntity.self
    ])
    let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: schema, configurations: [configuration])

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
        StoreEntity.self
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
