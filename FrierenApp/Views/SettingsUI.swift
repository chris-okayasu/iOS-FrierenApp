//
//  SettingsUI.swift
//  FrierenApp
//
//  Created by chris on 2024/10/06.
//

import SwiftUI

struct SettingsUI: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var books: [BookStatus] = [.active, .active, .inactive, .locked, .locked, .locked , .locked, .locked, .locked, .locked]
    
    var body: some View {
        ZStack{
            InfoBackgroundImage()
            VStack{
                Text("Which books would you like to see questions from?")
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding(.top)
                
                ScrollView{
                    LazyVGrid(columns: [GridItem(), GridItem()]){
                        ForEach(0..<books.count, id: \.self) { i in
                            // Usamos el componente BookView
                            BookView(index: i, status: $books[i])  // Pasamos el estado con Binding
                        }
                        .padding()
                    }
                }
                
                Button("Done"){
                    dismiss()
                }
                .doneButton()
                .foregroundColor(Color("simple-black"))
            }
        }
    }
}

#Preview {
    SettingsUI()
}
