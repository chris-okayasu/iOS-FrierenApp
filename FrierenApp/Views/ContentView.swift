//
//  ContentView.swift
//  FrierenApp
//
//  Created by chris on 2024/10/02.
//

import SwiftUI
import AVKit

struct ContentView: View {
    @EnvironmentObject private var store: Store
    @EnvironmentObject private var game: Game
    @State private var audioPlayer: AVAudioPlayer!
//        @Environment(\.colorScheme) var colorScheme
    @State private var scalePlayButton = false
    @State private var moveBackgroundImage = false
    @State private var animateViewsIn = false
    @State private var showInstructions = false
    @State private var settingsOpen = false
    @State private var playGame = false
    
    var body: some View {
        
        GeometryReader{ geo in // for the size of the screen
            
            ZStack{
                // MARK: background image
                Image(.frieren)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width * 3, height: geo.size.height)
                    .padding(.leading,170)
                    .offset(x: moveBackgroundImage ? geo.size.width/2 : -geo.size.width/1.3)
                    .onAppear{
                        withAnimation(.linear(duration: 60).repeatForever()){
                            moveBackgroundImage.toggle()
                        }
                    }
                                
                // Title section
                // So we need both vstack and if because if will trigger the .onAppear()
                // however since we are adding .animation the IF statement cannot handle with that feature since it works for views like VStack or smiliar not for bools, so if animateViewsIn is true it means we are in this screen and each button is contained by its VStack and we can animate that VStack if is false the VStack will be just empty and nothing happens
                VStack{
                    // MARK: title section
                    VStack{
                        AnimatedVStack(animateViewsIn: animateViewsIn, animationDuration: 2, animationDelay: 2) {
                            VStack {
                                Image(systemName: "sparkles")
                                    .symbolEffect(.wiggle.up.byLayer)
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
                            .transition(.move(edge: .top)) // Transición aplicada al contenido del VStack, no al AnimatedVStack
                        }
                    }
                    Spacer()
                    
                    // MARK: score section
                    VStack{
                        AnimatedVStack(animateViewsIn: animateViewsIn, animationDuration: 2, animationDelay: 2) {
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
                        }
                    }
                    .animation(.linear(duration: 2).delay(4), value: animateViewsIn)
                    
                    // MARK: buttons
                    HStack {
                        AnimatedVStack(animateViewsIn: animateViewsIn, animationDuration: 2, animationDelay: 4) {
                            // Info Button
                            
                            Button{
                                // Instructions
                                showInstructions.toggle()
                            } label: {
                                Image(systemName: "info.circle.fill")
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                                    .shadow(radius: 10)
                            }
                            .transition(.offset(x: -geo.size.width / 3))
                            
                        }
                        
                        .animation(.easeOut(duration: 2).delay(3), value: animateViewsIn)
                        .padding(.trailing, 20)
                        
                        // MARK: Play Button
                        VStack{
                            AnimatedVStack(animateViewsIn: animateViewsIn, animationDuration: 2, animationDelay: 2) {
                                Button{
                                    // Start the game
                                    playGame.toggle()
                                } label: {
                                    Text("Play")
                                        .font(.largeTitle)
                                        .foregroundColor(.white)
                                        .padding(.vertical, 7)
                                        .padding(.horizontal, 50)
                                        .background(Color("first-color"))
                                        .cornerRadius(10)
                                        .shadow(radius: 10)
                                }
                                
                                .scaleEffect(scalePlayButton ? 1.2 : 1)
                                .onAppear{
                                    withAnimation(.easeInOut(duration: 1.3).repeatForever()) {
                                        scalePlayButton.toggle()
                                    }
                                }
                                .transition(.offset(y: geo.size.height/3))
                            }
                            
                        }
                        .animation(.easeOut(duration: 1).delay(2), value: animateViewsIn)
                        
                        
                        VStack{
                            AnimatedVStack(animateViewsIn: animateViewsIn, animationDuration: 2, animationDelay: 4) {
                                Button{
                                    // setitngs
                                    settingsOpen.toggle()
                                } label: {
                                    Image(systemName: "gearshape.fill")
                                        .font(.largeTitle)
                                        .foregroundColor(.white)
                                        .shadow(radius: 10)
                                }
                                .transition(.offset(x: geo.size.width/3))
                            }
                            
                        }
                        .animation(.easeOut(duration: 2).delay(3), value: animateViewsIn)
                        .padding(.leading, 20)
                    }
                    Spacer(minLength: 100)
                    
                }
            }
            .frame(width: geo.size.width, height: geo.size.height) // center ZStack
            
        } // end of geometry
        
        .ignoresSafeArea() // use whole screen for geometry reader
        
        .onAppear { // Once the View appears
            animateViewsIn = true
//            SoundManager.shared.mainPageMusic()
        }
        
        .sheet(isPresented: $showInstructions){
            InstructionsUI()
        }
        
        .sheet(isPresented: $settingsOpen){
            SettingsUI()
                .environmentObject(Store())
        }
        
        .fullScreenCover(isPresented: $playGame){
            Gameplay()
                .environmentObject(Game())
        }
        
    }
    
//    private func playAudio() {
//        let sound = Bundle.main.path(forResource: "magic-in-the-air", ofType: "mp3")
//        audioPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
//        audioPlayer.numberOfLoops = -1
//        audioPlayer.play()
//    }
}

#Preview {
    ContentView()
        .environmentObject(Store())
        .environmentObject(Game())
}
