//
//  SettingsUI.swift
//  FrierenApp
//
//  Created by chris on 2024/10/06.
//

import SwiftUI

struct SettingsUI: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack{
            InfoBackgroundImage()
            VStack{
                Text("Which books would you like to see questions from?")
                    .font(.title)
                    .multilineTextAlignment(.center)
                
                ScrollView{
                    LazyVGrid(columns: [GridItem(), GridItem()]){
                        ZStack(alignment: .bottomTrailing){
                            Image(.manga1)
                                .resizable()
                                .scaledToFit()
                                .shadow(radius: 7)
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title)
                                .imageScale(.large)
                                .foregroundColor(.green)
                                .shadow(radius: 1)
                                .padding(3)
                        }
                        
                        ZStack(alignment: .bottomTrailing){
                            Image(.manga2)
                                .resizable()
                                .scaledToFit()
                                .shadow(radius: 7)
                                .overlay(Rectangle().opacity(0.4))
                            Image(systemName: "circle")
                                .font(.title)
                                .imageScale(.large)
                                .foregroundColor(.green.opacity(0.5))
                                .shadow(radius: 1)
                                .padding(3)
                        }
                        
                        ZStack {
                            Image(.manga3)
                                .resizable()
                                .scaledToFit()
                                .shadow(radius: 7)
                                .overlay(Rectangle().opacity(0.8))
                            Image(systemName: "lock.fill")
                                .font(.title)
                                .imageScale(.large)
                                .shadow(color: .white.opacity(0.5), radius: 3)
                                .padding(3)
                        }
                    }
                    .padding()
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
