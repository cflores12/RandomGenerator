import Foundation
import SwiftUI
import WidgetKit

class WidgetConfigViewModel: ObservableObject {
    @Published var selectedWidgetType: String = UserDefaults(suiteName: "group.com.randomgenerator.app")?.string(forKey: "widgetType") ?? "numbers"
    
    // Numbers settings
    @Published var minValueText: String = String(UserDefaults(suiteName: "group.com.randomgenerator.app")?.integer(forKey: "minValue") ?? 1)
    @Published var maxValueText: String = String(UserDefaults(suiteName: "group.com.randomgenerator.app")?.integer(forKey: "maxValue") ?? 100)
    @Published var numberCount: Int = UserDefaults(suiteName: "group.com.randomgenerator.app")?.integer(forKey: "numberCount") ?? 3
    
    // Dice settings
    @Published var diceCount: Int = UserDefaults(suiteName: "group.com.randomgenerator.app")?.integer(forKey: "diceCount") ?? 2
    @Published var diceType: Int = UserDefaults(suiteName: "group.com.randomgenerator.app")?.integer(forKey: "diceType") ?? 6
    let diceTypes = [4, 6, 8, 10, 12, 20, 100]
    
    // Coin settings
    @Published var coinCount: Int = UserDefaults(suiteName: "group.com.randomgenerator.app")?.integer(forKey: "coinCount") ?? 3
    
    // Preview data
    @Published var previewNumbers: [Int] = []
    @Published var previewDiceResults: [Int] = []
    @Published var previewCoinResults: [Bool] = []
    
    init() {
        updatePreview()
    }
    
    func saveWidgetType() {
        UserDefaults(suiteName: "group.com.randomgenerator.app")?.set(selectedWidgetType, forKey: "widgetType")
        updatePreview()
    }
    
    func saveConfiguration() {
        // Save numbers settings
        if let minValue = Int(minValueText) {
            UserDefaults(suiteName: "group.com.randomgenerator.app")?.set(minValue, forKey: "minValue")
        }
        
        if let maxValue = Int(maxValueText) {
            UserDefaults(suiteName: "group.com.randomgenerator.app")?.set(maxValue, forKey: "maxValue")
        }
        
        UserDefaults(suiteName: "group.com.randomgenerator.app")?.set(numberCount, forKey: "numberCount")
        
        // Save dice settings
        UserDefaults(suiteName: "group.com.randomgenerator.app")?.set(diceCount, forKey: "diceCount")
        UserDefaults(suiteName: "group.com.randomgenerator.app")?.set(diceType, forKey: "diceType")
        
        // Save coin settings
        UserDefaults(suiteName: "group.com.randomgenerator.app")?.set(coinCount, forKey: "coinCount")
        
        // Reload widgets
        WidgetCenter.shared.reloadAllTimelines()
        
        // Update preview
        updatePreview()
    }
    
    func updatePreview() {
        switch selectedWidgetType {
        case "numbers":
            let min = Int(minValueText) ?? 1
            let max = Int(maxValueText) ?? 100
            previewNumbers = (1...numberCount).map { _ in Int.random(in: min...max) }
            previewDiceResults = []
            previewCoinResults = []
            
        case "dice":
            previewDiceResults = (1...diceCount).map { _ in Int.random(in: 1...diceType) }
            previewNumbers = []
            previewCoinResults = []
            
        case "coins":
            previewCoinResults = (1...coinCount).map { _ in Bool.random() }
            previewNumbers = []
            previewDiceResults = []
            
        default:
            break
        }
    }
}
