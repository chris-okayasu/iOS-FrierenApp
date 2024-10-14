//
//  Gameplay.swift
//  FrierenApp
//
//  Created by chris on 2024/10/11.
//

import SwiftUI

struct Gameplay: View {
    
    @Environment(\.dismiss) private var dissmiss
    
    @State private var animateViewsIn: Bool = false
    @State private var tappedCorrectAnswer: Bool = false
    @State private var hintWiggle:Bool = false
    @State private var scaleNextButton: Bool = false
    @State private var movePointsToScore: Bool = false
    @State private var revealHint: Bool = false
    @State private var revealManga: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image(.frieren)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width * 3, height: geo.size.height)
                    .padding(.leading,190)
                    .overlay(Rectangle().foregroundColor(.black.opacity(0.6)))
                
                VStack {
                    
                    // MARK: Controls
                    HStack {
                        Button("End Game"){
                            // MARK: End the game
                            dissmiss()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red.opacity(0.4))
                        Spacer()
                        
                        Text("Score: 22")
                            .font(.headline)
                    }
                    .padding()
                    .padding(.vertical, 40)
                    
                    // MARK: Question
                    VStack{
                        if animateViewsIn {
                            Text("Who is Friend?")
                                .font(.custom(Constants.titleFont, size:50))
                                .multilineTextAlignment(.center)
                                .padding()
                                .transition(.scale)
                        }
                    }
                    .animation(.easeInOut(duration: 2), value: animateViewsIn)
                    Spacer()
                    
                    // MARK: Hints
                    HStack {
                        if animateViewsIn {
                            Image(systemName: "questionmark.app.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100)
                                .foregroundColor(.cyan)
                                .rotationEffect(.degrees(hintWiggle ? -13 : -17))
                                .padding()
                                .padding(.leading, 20)
                                .transition(.scale)
                                .onAppear {
                                    withAnimation(.easeInOut(duration:0.1).repeatCount(10).delay(5).repeatForever()){
//                                        hintWiggle = true
                                    }
                                }
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 1)){
                                        revealHint = true
                                    }
                                }
                                .rotation3DEffect(.degrees(revealHint ? 1440 : 0), axis: (x:0, y:1, z:0))
                                .scaleEffect(revealHint ? 5 : 1)
                                .opacity(revealHint ? 0 : 1)
                                .offset(x: revealHint ? geo.size.width/2 : 0)
                                .overlay(
                                    Text("hint here")
                                        .padding(.leading, 33)
                                        .minimumScaleFactor(0.5)
                                        .multilineTextAlignment(.center)
                                        .opacity(revealHint ? 1 : 0)
                                        .scaleEffect(revealHint ? 1.5 : 1)
                                )
                            Spacer()
                            Image(systemName: "book.closed")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50)
                                .foregroundColor(.black)
                                .frame(width: 100, height: 100)
                                .background(.cyan)
                                .cornerRadius(20)
                                .rotationEffect(.degrees(hintWiggle ? 13 : 17))
                                .padding()
                                .padding(.trailing, 20)
                                .transition(.scale)
                                .onAppear {
                                    withAnimation(.easeInOut(duration:0.1).repeatCount(10).delay(5).repeatForever()){
//                                        hintWiggle = true
                                    }
                                }
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 1)){
                                        revealManga = true
                                    }
                                }
                                .rotation3DEffect(.degrees(revealManga ? 1440 : 0), axis: (x:0, y:1, z:0))
                                .scaleEffect(revealManga ? 5 : 1)
                                .opacity(revealManga ? 0 : 1)
                                .offset(x: revealManga ? -geo.size.width/2 : 0)
                                .overlay(
                                    Text("hint here")
                                        .padding(.trailing, 33)
                                        .minimumScaleFactor(0.5)
                                        .multilineTextAlignment(.center)
                                        .opacity(revealManga ? 1 : 0)
                                        .scaleEffect(revealManga ? 1.5 : 1)
                                )
                        }
                    }
                    
                    .animation(.easeInOut(duration: 2), value: animateViewsIn)
                    .padding(.bottom)
                    
                    // MARK: Answers
                    LazyVGrid(columns: [GridItem(), GridItem()]) {
                        ForEach(1..<5) { i in
                            Text("Answer \(i)")
                                .minimumScaleFactor(0.5)
                                .multilineTextAlignment(.center)
                                .padding(10)
                                .frame(width: geo.size.width / 2.15, height: 90)
                                .background(Color.green.opacity(0.5))
                                .cornerRadius(25)
                                .offset(x: animateViewsIn ? 0 : (i % 2 == 0 ? geo.size.width : -geo.size.width)) // Desplazamos fuera si es falso.
                                .animation(.easeInOut(duration: 1).delay(Double(i) * 0.2), value: animateViewsIn)
                        }
                    }
                    Spacer()
                }
                .frame(width: geo.size.width, height: geo.size.height)
                .foregroundStyle(.white)
                
                
                // MARK: Celebration
                VStack {
                    Spacer()
                    VStack{
                        if tappedCorrectAnswer {
                            Text("5") // Score
                                .font(.largeTitle)
                                .padding(.top, 20)
                                .transition(.offset(y: -geo.size.height/4))
                                .offset(x: movePointsToScore ? geo.size.width/2.3 : 0, y: movePointsToScore ? -geo.size.height/13 : 0)
                                .opacity(movePointsToScore ? 0 : 1)
                                .onAppear {
                                    withAnimation(.easeInOut(duration: 1).delay(3)){
                                        movePointsToScore = true
                                    }
                                }
                        }
                    }
                    
                    .animation(.easeInOut(duration:1).delay(2), value: tappedCorrectAnswer)
                    
                    Spacer()
                    VStack {
                        if tappedCorrectAnswer {
                            Text("Brilliant!")
                                .font(.custom(Constants.titleFont, size: 100))
                                .transition(.blurReplace)
                        }
                    }
                    .animation(.easeInOut(duration:1).delay(1), value: tappedCorrectAnswer)
                    Spacer()
                    
//                    VStack {
                        if tappedCorrectAnswer {
                            
                            Text("Answer 1")
                                .minimumScaleFactor(0.5)
                                .multilineTextAlignment(.center)
                                .padding(10)
                                .frame(width: geo.size.width/2.15, height: 80)
                                .background(Color.green.opacity(0.5))
                                .cornerRadius(25)
                                .scaleEffect(2)
                                
                        }
//                    }
//                    .animation(.easeInOut(duration:1).delay(1), value: tappedCorrectAnswer)
                    
                    Group {
                        Spacer()
                        Spacer()
                    }
                    
                    VStack{
                        if tappedCorrectAnswer {
                            Button("Next Question → "){
                                // TODO: Go to the next question
                                animateViewsIn.toggle()
//                                tappedCorrectAnswer = false
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.blue.opacity(0.5))
                            .font(.largeTitle)
                            .transition(.offset(y: geo.size.height/4))
                            .scaleEffect(scaleNextButton ? 1.2 : 1 )
                            .onAppear {
                                withAnimation(.easeInOut(duration:1.3).repeatForever()) {
                                    scaleNextButton.toggle()
                                }
                            }
                        }
                    }
                    .animation(.easeInOut(duration:1).delay(2), value: tappedCorrectAnswer)
                    Spacer()
                    
                }
                .foregroundColor(.white)
            }
            .frame(width: geo.size.width, height: geo.size.height) // center image
        }
        .ignoresSafeArea()
        
        .onAppear {
//                tappedCorrectAnswer = true
                animateViewsIn = true

        }
    }
}

#Preview {
    Gameplay()
}
