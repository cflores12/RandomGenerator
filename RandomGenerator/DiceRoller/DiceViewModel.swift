import Foundation
import SwiftUI
import Combine

class DiceViewModel: ObservableObject {
    @Published var diceCount: Int = 2
    @Published var diceType: Int = 6
    @Published var diceResults: [Int] = []
    @Published var isRolling: Bool = false
    @Published var totalValue: Int = 0
    @Published var copiedFeedback: Bool = false
    
    let diceTypes = [4, 6, 8, 10, 12, 20, 100]
    
    private var model = DiceModel(count: 2, type: 6)
    
    func rollDice() {
        isRolling = true
        
        // Update model and roll dice
        model.count = diceCount
        model.type = diceType
        model.rollDice()
        
        // Update UI
        diceResults = model.results
        totalValue = model.total
        copiedFeedback = false
        
        isRolling = false
    }
    
    func copyDiceResults() {
        let resultsText = diceResults.map { String($0) }.joined(separator: ", ") + " (Total: \(totalValue))"
        ClipboardService.copyToClipboard(resultsText)
        copiedFeedback = true
        
        // Reset the feedback after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.copiedFeedback = false
        }
    }
}