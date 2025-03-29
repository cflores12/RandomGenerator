import Foundation

struct NumberGeneratorModel {
    var minValue: Int
    var maxValue: Int
    var count: Int
    var generatedNumbers: [Int] = []
    
    mutating func generateNumbers() {
        guard minValue < maxValue && count > 0 else { return }
        generatedNumbers = (1...count).map { _ in Int.random(in: minValue...maxValue) }
    }
}