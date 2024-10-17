import Foundation
import StoreKit

// Enum defining the state of each book, which can be: active, inactive, or locked
enum BookStatus {
    case active    // The book is available and can be accessed
    case inactive  // The book is currently not available
    case locked    // The book is locked and requires a purchase
}

@MainActor
class Store: ObservableObject {
    
    // Array representing the status of each book in the store
    // Initially, the first two are active, the third is inactive, and the rest are locked
    @Published var books: [BookStatus] = [.active, .active, .inactive, .locked, .locked, .locked, .locked, .locked, .locked, .locked]
    
    // Array that will hold the available products (books) from the App Store
    @Published var products: [Product] = []
    
    // Set that stores the IDs of purchased products (books)
    // A Set is used to ensure that the same product can't be purchased twice
    @Published var purchasedIDs = Set<String>()
    
    // List of product IDs that represent the purchasable books
    private var productIDs = ["frieren4", "frieren5", "frieren6", "frieren7", "frieren8", "frieren9", "frieren10"]
    
    // A task that will monitor for updates in purchases
    private var updates: Task<Void, Never>? = nil
    
    // Initializer for the Store class
    // Starts listening for updates and loads the available products from the App Store
    init() {
        updates = watchForUpdates()  // This starts monitoring for transaction updates
        Task {
            await loadProducts()  // This fetches the list of available products asynchronously
        }
    }

    // Function to load the products (books) from the App Store
    // It fetches the products based on the productIDs array and assigns them to the `products` array
    func loadProducts() async {
        do {
            // Attempt to fetch the products using the StoreKit API
            products = try await Product.products(for: productIDs)
        } catch {
            // If there's an error, it gets printed to the console
            print("Couldn't fetch those products: \(error)")
        }
    }
    
    // Function to handle the purchase of a product
    // Takes a `Product` as a parameter and attempts to purchase it asynchronously
    func purchase(_ product: Product) async {
        do {
            // Try to purchase the product and get the result
            let result = try await product.purchase()
            
            // Handle the different outcomes of the purchase
            switch result {
                
            case .success(let verificationResult):
                
                // After the purchase succeeds, we need to verify the transaction
                switch verificationResult {
                    
                case .verified(let signedType):
                    // If the transaction is verified, add the product ID to the purchasedIDs set
                    purchasedIDs.insert(signedType.productID)
                    
                case .unverified(let signedType, let verificationError):
                    // If the transaction is unverified, log the error
                    print("Error on \(signedType): \(verificationError)")
                }
                
            // The purchase is pending approval, possibly waiting for a parent or other action
            case .pending:
                break
                
            // The user canceled the purchase (or it was not approved)
            case .userCancelled:
                break
                
            // Default case for future possibilities (e.g., new features from Apple)
            @unknown default:
                break
            }
            
        } catch {
            // Log any errors that occur during the purchase process
            print("Couldn't purchase that product: \(error)")
        }
    }
    
    // Function to check the currently purchased products
    // Iterates through the available products and checks if they are already purchased
    private func checkPurchased() async {
        
        // Iterate over each product in the `products` array
        for product in products {
            // Get the current entitlement status for each product (i.e., whether it's been purchased)
            guard let state = await product.currentEntitlement else { return }
            
            // Handle the entitlement state
            switch state {
                
            case .unverified(let signedType, let verificationError):
                // Log an error if the purchase is unverified
                print("Error on \(signedType): \(verificationError)")
                
            case .verified(let signedType):
                // If the product is verified and hasn't been revoked, add it to the purchasedIDs set
                if signedType.revocationDate == nil {
                    purchasedIDs.insert(signedType.productID)
                } else {
                    // If the product has been revoked, remove it from the purchasedIDs set
                    purchasedIDs.remove(signedType.productID)
                }
                
            @unknown default:
                break
            }
        }
    }
    
    // Function to watch for updates in purchases
    // This function continuously listens for new transactions, allowing for the app to update automatically
    private func watchForUpdates() -> Task<Void, Never> {
        return Task(priority: .background) {
            // Use StoreKit's Transaction.updates to monitor for any transaction updates
            for await _ in Transaction.updates {
                // Each time there's an update, check if any products have been purchased or revoked
                await checkPurchased()
            }
        }
    }
}
