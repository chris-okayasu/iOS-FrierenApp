import Foundation

@MainActor
class Game: ObservableObject {
    // Stores all questions from the JSON
    private var allQuestions: [QuestionModel] = []
    // Keeps track of answered questions by their IDs
    private var answeredQuestions: [Int] = []
    // Questions filtered by manga
    var filteredQuestions: [QuestionModel] = []
    // Currently active question
    @Published var currentQuestion = Constants.previewQuestion // Marked as @Published to notify views on changes
    
    init() {
        decodeQuestions() // Decode the questions as soon as the game is started
    }
    
    // Filters questions based on selected manga IDs
    func filterQuestions(to manga: [Int]) {
        filteredQuestions = allQuestions.filter { manga.contains($0.manga) }
    }
    
    // Generates a new random question that has not been answered yet
    func newQuestion() {
        if filteredQuestions.isEmpty {
            return // If there are no filtered questions, exit the function
        }
        
        // Reset answered questions if all have been answered
        if answeredQuestions.count == filteredQuestions.count {
            answeredQuestions = []
        }
        
        // Get a random question and ensure it hasn't been answered yet
        var potentialQuestion = filteredQuestions.randomElement()!
        while answeredQuestions.contains(potentialQuestion.id) {
            potentialQuestion = filteredQuestions.randomElement()!
        }
        
        // Update the current question
        currentQuestion = potentialQuestion
    }
    
    // Decodes questions from a local JSON file
    private func decodeQuestions() {
        if let url = Bundle.main.url(forResource: "trivia", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let questions = try JSONDecoder().decode([QuestionModel].self, from: data)
                allQuestions = questions
                filteredQuestions = allQuestions // Initially, all questions are filtered
            } catch {
                print("Error decoding JSON data: \(error)") // Handle the error gracefully
            }
        }
    }
}

