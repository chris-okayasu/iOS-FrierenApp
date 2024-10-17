//
//  QuestionModel.swift
//  FrierenApp
//
//  Created by chris on 2024/10/17.
//

import Foundation

struct QuestionModel: Codable {
    let id: Int
    let question: String
    var answers: [String: Bool] = [:]
    let manga: Int
    let hint: String
    
    enum QuestionKeys: String, CodingKey { // It has to match with JSON or API Response or whereve is the data come from
        case id
        case question
        case answer
        case wrong
        case manga
        case hint
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: QuestionKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        question = try container.decode(String.self, forKey: .question)
        manga = try container.decode(Int.self, forKey: .manga)
        hint = try container.decode(String.self, forKey: .hint)
        
        let correctAnswer = try container.decode(String.self, forKey: .answer)
        answers[correctAnswer] = true
        let wrongAnswer = try container.decode([String].self, forKey: .wrong)
        wrongAnswer.forEach { answers[$0] = false }
    }
    
    /*
     how the book (var answers: [String: Bool] = [:]) looks like:
         answers
            {
             "Revisitar los recuerdos de sus compañeros": true,
             "Buscar nuevos aliados": false,
             "Entrenar en magia avanzada": false,
             "Derrotar a nuevos enemigos": false
            }
     */
    
    
    
}
