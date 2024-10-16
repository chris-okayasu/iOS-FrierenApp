import SwiftUI

// Componente para cada libro según su estado
struct BookView: View {
    
    let index: Int
    @Binding var status: BookStatus  // To modify the view that uses that status
    @EnvironmentObject private var store: Store
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Image("manga\(index+1)")  // to load books
                .resizable()
                .scaledToFit()
                .shadow(radius: 7)
                .overlay(statusOverlay()) // to overlay the status

            iconForStatus() // icon design
                .font(.title)
                .imageScale(.large)
                .shadow(radius: 1)
                .padding(3)
        }
        
        
        .onTapGesture {
            if status == .inactive {
                // Activa el libro
                status = .active
            } else if status == .active {
                // Desactiva el libro
                status = .inactive
            } else if status == .locked {
                if index >= 3, index - 3 < store.products.count { // Asegúrate de que el índice sea válido
                    let product = store.products[index - 3]
                    Task {
                        await store.purchase(product)
                        
                        // Actualiza el estado del libro después de la compra
                        if store.purchasedIDs.contains(product.id) { // Verifica si se ha comprado correctamente
                            DispatchQueue.main.async {
                                store.books[index] = .active // Cambia el estado a activo después de la compra
                            }
                        }
                    }
                } else {
                    print("Índice fuera de rango para productos, index: \(index), products.count: \(store.products.count)")
                }
            }
        }





    }

    @ViewBuilder
    private func statusOverlay() -> some View {
        switch status {
        case .active:
            Rectangle().foregroundColor(.clear) // No hay overlay para activos
        case .inactive:
            Rectangle().foregroundColor(.black).opacity(0.4) // Overlay semi-opaco para inactivos
        case .locked:
            Rectangle().foregroundColor(.black).opacity(0.8) // Overlay oscuro para bloqueados
        }
    }
    private func iconForStatus() -> some View {
        let image: Image
        
        switch status {
        case .active:
            image = Image(systemName: "checkmark.circle.fill")
        case .inactive:
            image = Image(systemName: "circle")
        case .locked:
            image = Image(systemName: "lock.fill")
        }
        
        return image
            .font(.title)
            .imageScale(.large)
            .foregroundColor(iconColor())
            .shadow(radius: status == .locked ? 3 : 1)
            .padding(3)
    }

    private func iconColor() -> Color {
        switch status {
        case .active:
            return .green
        case .inactive:
            return .green.opacity(0.5)
        case .locked:
            return .white.opacity(0.5)
        }
    }
}

#Preview {
    // a local state just for preview
    @Previewable @State var previewStatus: BookStatus = .active

    // using the binding to the view
    return BookView(index: 0, status: $previewStatus)
}
