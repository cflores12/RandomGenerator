import Foundation

struct CoinModel {
    var count: Int
    var results: [Bool] = []
    
    var headsCount: Int {
        results.filter { $0 }.count
    }
    
    var tailsCount: Int {
        results.count - headsCount
    }
    
    mutating func flipCoins() {
        results = (1...count).map { _ in Bool.random() }
    }
}