//
//  FrierenAppApp.swift
//  FrierenApp
//
//  Created by chris on 2024/10/02.
//

import SwiftUI

@main
struct FrierenAppApp: App {
    @StateObject private var store = Store()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .task {
                    await store.loadProducts()
                }
        }
    }
}
