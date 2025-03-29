import Foundation

struct DiceModel {
    var count: Int
    var type: Int
    var results: [Int] = []
    
    var total: Int {
        results.reduce(0, +)
    }
    
    mutating func rollDice() {
        results = (1...count).map { _ in Int.random(in: 1...type) }
    }
}