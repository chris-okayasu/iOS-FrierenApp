//
//  Store.swift
//  FrierenApp
//
//  Created by chris on 2024/10/16.
//

import Foundation
import StoreKit

enum BookStatus {
    case active
    case inactive
    case locked
}

@MainActor
class Store: ObservableObject {
    
    @Published var books: [BookStatus] = [.active, .active, .inactive, .locked, .locked, .locked , .locked, .locked, .locked, .locked]
    
    @Published var products: [Product] = []
    
    @Published var purchasedIDs = Set<String>() // set makes the values unique since no one should buy the same manga twice
    
    private var productIDs = ["frieren4","frieren5","frieren6","frieren7","frieren8","frieren9","frieren10"]
    
    private var updates: Task<Void, Never>? = nil
    
    init() {
        updates = watchForUpdates()
        Task {
            await loadProducts() // load products
        }
    }

    
    func loadProducts() async {
        do{
            products = try await Product.products(for: productIDs)
        } catch {
            print("Counldn't fetch those products: \(error)")
        }
    }
    
    func purchase(_ product: Product) async {
        do {
            let result = try await product.purchase()
            switch result {
                
            case .success(let VerificationResult):
                
                
                switch VerificationResult {
                    
                case .verified(let signedtype):
                    purchasedIDs.insert(signedtype.productID)
                    
                    
                case .unverified(let signedType, let verifiationError):
                    print("Error on \(signedType): \(verifiationError)")
                }
                
                // Waiting for approval
            case .pending:
                break
                
                // User cancelld or parent disappoved the purchase request
            case .userCancelled:
                break
                
                // possible features in the future (By Apple)
            @unknown default:
                break
            }
        } catch {
            print("Couldn't purchase that product: \(error)")
        }
    }
    
    func restorePurchases() async {
        do {
            let result = try await AppStore.sync()
            print("Restauración completa: \(result)")
            
            await checkPurchased() // Verifica los productos restaurados
        } catch {
            print("Error restaurando las compras: \(error)")
        }
    }

    
    private func checkPurchased() async {
        
        for product in products {
            guard let state = await product.currentEntitlement else { return }
            
            switch state {
            case .unverified(let signedType, let verifiationError):
                print("Error on \(signedType): \(verifiationError)")
                
            case .verified(let signedType):
                if signedType.revocationDate == nil {
                    purchasedIDs.insert(signedType.productID)
                } else {
                    purchasedIDs.remove(signedType.productID)
                }
                
            @unknown default:
                break
            }
        }
    }
    // To buy a book not in the Frieren App but in the AppStore since people can log into AppStore and buy a manga from there
    private func watchForUpdates() -> Task<Void, Never> {
        return Task(priority: .background) {
            for await _ in Transaction.updates {
                await checkPurchased()
            }
        }
    }
}
