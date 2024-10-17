//
//  Game.swift
//  FrierenApp
//
//  Created by chris on 2024/10/17.
//

import Foundation

@MainActor
class Game: ObservableObject {
    @Published var gameScore: Int = 0
    @Published var questionScore: Int = 5
    @Published var recentScores: [Int] = [0,0,0]
    @Published var higherScore: Int = 0
    
    private var allQuestions: [QuestionModel] = []
    private var answeredQuestions: [Int] = []
    var filteredQuestions: [QuestionModel] = []
    var currentQuestion = Constants.previewQuestion
    var answers: [String] = []
    
    var correctAnswer: String {
        currentQuestion.answers.first(where: {$0.value == true})!.key
    }
    
    init () {
        decodeQuestions() // decode the questions as soon as the game is started
    }
    func startGame () {
        gameScore = 0
        questionScore = 5
        answeredQuestions = []
    }
    
    func filterQuestions(to manga: [Int]) {
        filteredQuestions = allQuestions.filter{ manga.contains($0.manga)}
    }
    
    func newQuestion() {
        
        if filteredQuestions.isEmpty {
            return
        }
        
        // Reset the question is already answer all the questions
        if answeredQuestions.count == filteredQuestions.count {
            answeredQuestions = []
        }
        
        // Get a random question, if answeredQuestions contains the id go into while and get a new one
        // this should not be infinite since if all of them are already answered the code will blank the array answeredQuestions = []
        var potentialQuestion = filteredQuestions.randomElement()!
        while answeredQuestions.contains(potentialQuestion.id) {
            potentialQuestion = filteredQuestions.randomElement()!
        }
        currentQuestion = potentialQuestion
        
        answers = []
        for a in currentQuestion.answers.keys {
            answers.append(a)
        }
        answers.shuffle() // just deorganize de array
        questionScore = 5
    }
    
    func correct() {
        answeredQuestions.append(currentQuestion.id)
        // TODO: Update score
        gameScore += questionScore
    }
    
    func endGame() {
        recentScores[2] = recentScores[1]
        recentScores[1] = recentScores[0]
        recentScores[0] = gameScore
    }
    
    func bestScore(){
        if let maxRecentScore = recentScores.max() {
                if higherScore < maxRecentScore {
                    higherScore = maxRecentScore
                }
            }
    }
    
    private func decodeQuestions() {
        if let url = Bundle.main.url(forResource: "trivia", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let questions = try JSONDecoder().decode([QuestionModel].self, from: data)
                allQuestions = questions
                filteredQuestions = allQuestions
            } catch {
                print("Error decoding JSON data: \(error)")
            }
        }
    }
    
}
