import Foundation
import SwiftUI
import Combine

class NumberGeneratorViewModel: ObservableObject {
    @Published var minValueText: String = ""
    @Published var maxValueText: String = ""
    @Published var countText: String = "5"
    @Published var generatedNumbers: [Int] = []
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    @Published var copiedFeedback: String? = nil
    
    private var model = NumberGeneratorModel(minValue: 1, maxValue: 100, count: 5)
    
    func generateRandomNumbers() {
        // Validate inputs
        guard let min = Int(minValueText) else {
            showErrorMessage("Please enter a valid minimum value")
            return
        }
        
        guard let max = Int(maxValueText) else {
            showErrorMessage("Please enter a valid maximum value")
            return
        }
        
        guard let count = Int(countText), count > 0 else {
            showErrorMessage("Please enter a valid number of values to generate")
            return
        }
        
        if min >= max {
            showErrorMessage("Maximum value must be greater than minimum value")
            return
        }
        
        // Update model and generate numbers
        model.minValue = min
        model.maxValue = max
        model.count = count
        model.generateNumbers()
        
        // Update UI
        generatedNumbers = model.generatedNumbers
        copiedFeedback = nil
    }
    
    func copyAllNumbers() {
        let numbersText = generatedNumbers.map { String($0) }.joined(separator: ", ")
        ClipboardService.copyToClipboard(numbersText)
        copiedFeedback = "all"
        
        // Reset the feedback after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if self.copiedFeedback == "all" {
                self.copiedFeedback = nil
            }
        }
    }
    
    func copySingleNumber(_ number: Int) {
        ClipboardService.copyToClipboard(String(number))
        copiedFeedback = "\(number)"
        
        // Reset the feedback after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if self.copiedFeedback == "\(number)" {
                self.copiedFeedback = nil
            }
        }
    }
    
    private func showErrorMessage(_ message: String) {
        errorMessage = message
        showError = true
    }
}