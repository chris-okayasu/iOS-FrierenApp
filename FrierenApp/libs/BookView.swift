import SwiftUI

enum BookStatus {
    case active
    case inactive
    case locked
}

// Componente para cada libro según su estado
struct BookView: View {
    
    let index: Int
    @Binding var status: BookStatus  // Se usa Binding para modificar el estado desde la vista contenedora
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Image("manga\(index+1)")  // Se usa el índice para acceder a la imagen correcta
                .resizable()
                .scaledToFit()
                .shadow(radius: 7)
                .overlay(statusOverlay()) // Lógica para superponer la opacidad y el estado

            iconForStatus() // Ícono que se ajusta según el estado
                .font(.title)
                .imageScale(.large)
                .shadow(radius: 1)
                .padding(3)
        }
        .onTapGesture {
            // Cambiamos el estado cuando el libro es tocado
            if status == .inactive {
                status = .active
            } else if status == .active {
                status = .inactive
            } else if status == .locked {
                status = .active // Desbloquear si estaba bloqueado (esto es opcional según tu lógica)
            }
        }
    }

    // Método que devuelve una superposición basada en el estado del libro
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

    // Método que devuelve el ícono basado en el estado del libro
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

    // Método que devuelve el color del ícono según el estado
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
    // Creamos un estado local para usarlo en la vista previa
    @Previewable @State var previewStatus: BookStatus = .active

    // Pasamos el Binding del estado local a la vista
    return BookView(index: 0, status: $previewStatus)
}
