//
//  InstructionsUI.swift
//  FrierenApp
//
//  Created by chris on 2024/10/06.
//

import SwiftUI

struct InstructionsUI: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack{
            InfoBackgroundImage()
            
            VStack{
                Image(._375162)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                    .cornerRadius(20)
                    .padding(.top, (20))
                
                // scroll section
                Text("How to play")
                    .font(.largeTitle)
                    .padding()
                    .foregroundColor(Color("Simple-Black"))
                ScrollView{
                        
                    VStack(alignment: .leading){
                        Text("Welcome to Frieren Trivia App!!! In this game, you will be asked random questions from the Soso no Frieren Manga Books and you must guess the right answare or you will lose points! 😱")
                            .padding([.horizontal, .vertical])
//
                        Text("Each questiong is worth 5 points, but if you guess a wrong answer, you lose 1 point.")
                            .padding([.horizontal, .vertical])
                        
                        Text("If you are struggling to guess the right answer, you can use the hint button to see the correct answer. But beware! Using these also minuses 1 point each.")
                            .padding([.horizontal, .vertical])
                        
                        Text("When you select the correct answares you will be awarded all the pints left for that question and they will be added to your total score.")
                            .padding(.horizontal)
                    }
                    .font(.title3)
                    
                    Text("Good luck!")
                        .font(.title)
                        .padding(.top, 10)
                }
                .foregroundColor(Color("Simple-Black"))
                Button("Done"){
                    dismiss()
                }
                .doneButton()
            }
        }
    }
}

#Preview {
    InstructionsUI()
}
