import Foundation
import SwiftUI
import Combine

class CoinViewModel: ObservableObject {
    @Published var numberOfFlips: Int = 1
    @Published var coinResults: [Bool] = []
    @Published var isFlipping: Bool = false
    @Published var copiedFeedback: Bool = false
    
    private var model = CoinModel(count: 1)
    
    var headsCount: Int {
        model.headsCount
    }
    
    var tailsCount: Int {
        model.tailsCount
    }
    
    func flipCoins() {
        isFlipping = true
        
        // Update model and flip coins
        model.count = numberOfFlips
        model.flipCoins()
        
        // Update UI
        coinResults = model.results
        copiedFeedback = false
        
        isFlipping = false
    }
    
    func copyCoinResults() {
        let resultsText = coinResults.map { $0 ? "Heads" : "Tails" }.joined(separator: ", ") +
                         "\nSummary: Heads: \(headsCount), Tails: \(tailsCount)"
        
        ClipboardService.copyToClipboard(resultsText)
        copiedFeedback = true
        
        // Reset the feedback after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.copiedFeedback = false
        }
    }
}