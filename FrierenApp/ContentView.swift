//
//  ContentView.swift
//  FrierenApp
//
//  Created by chris on 2024/10/02.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader{ geo in // for the size of the screen
            
            ZStack{
                Image(.frieren)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width * 3, height: geo.size.height)
                    .padding(.leading,170)
                
                VStack{
                    VStack{
                        Image(systemName: "sparkles")
                            .symbolEffect(.wiggle.up.byLayer, options: .nonRepeating)
                            .font(.largeTitle)
                            .imageScale(.large)
                            .foregroundColor(.white)
                        Text("Sōsō no Frieren")
                            .font(.custom(Constants.titleFont, size: 70))
                            .padding(.bottom, -50)
                            .foregroundColor(.white)
                        Text("Trivia")
                            .font(.custom(Constants.titleFont, size: 60))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.top, 80)
                    
                    VStack{
                        Text("Recent Scores: ")
                            .font(.title2)
                            .padding(5)
                        Text("20")
                        Text("40")
                        Text("15")
                            .padding(.bottom, 20)
                    }
                    .font(.title3)
                    .padding(.horizontal)
                    .foregroundColor(.white)
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(15)
                    .padding(.bottom, 10)
                    
                    HStack {
                        Button{
                            // Show Instructions
                        } label: {
                            Image(systemName: "info.circle.fill")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                                .shadow(radius: 10)
                        }
                        Button{
                            // Start the game
                        } label: {
                            Text("Play")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                                .padding(.vertical, 7)
                                .padding(.horizontal, 50)
                                .background(Color.indigo)
                                .cornerRadius(10)
                                .shadow(radius: 10)
                        }
                        
                        Button{
                            // setitngs
                        } label: {
                            Image(systemName: "gearshape.fill")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                                .shadow(radius: 10)
                        }
                    }
                    Spacer()
                }
            }
            .frame(width: geo.size.width, height: geo.size.height) // center ZStack
            
        } // end of geometry
        .ignoresSafeArea() // use whole screen for geometry reader
    }
}

#Preview {
    ContentView()
}
