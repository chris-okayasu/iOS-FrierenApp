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
    @StateObject private var game = Game()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .environmentObject(game)
                .task {
                    await store.loadProducts()
                }
        }
    }
}
