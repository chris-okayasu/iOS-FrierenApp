//
//  SettingsUI.swift
//  FrierenApp
//
//  Created by chris on 2024/10/06.
//

import SwiftUI

struct SettingsUI: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: Store
    
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
                        ForEach(0..<store.books.count, id: \.self) { i in
                            BookView(index: i, status: $store.books[i])
                        }

                        .padding()
                    }
                }
                
                Button("Done"){
                    dismiss()
                }
                
                .doneButton()
                .foregroundColor(Color("simple-black"))
                .foregroundColor(.red)
            }
        }
    }
}

#Preview {
    SettingsUI()
        .environmentObject(Store())
}
