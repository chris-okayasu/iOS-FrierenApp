//
//  Feedback.swift
//  FrierenApp
//
//  Created by chris on 2024/10/16.
//

import UIKit
// notifications (vibration)
class Feedback {
    static let shared = Feedback() // Singleton -> only one instance of the entire app
    
    private init() {} // Now it is imposs
    
    // MARK: private functions
    private func wrongFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
    
    private func correctFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    // MARK: public functions
    func giveWrongFeedback() {
        wrongFeedback()
    }
    func giveCorrectFeedback() {
        correctFeedback()
    }
    
}
