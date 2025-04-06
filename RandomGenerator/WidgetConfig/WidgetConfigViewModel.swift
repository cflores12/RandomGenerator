import Foundation
import SwiftUI
import WidgetKit

class WidgetConfigViewModel: ObservableObject {
    // Use a computed property to safely access UserDefaults
    private var userDefaults: UserDefaults? {
        UserDefaults(suiteName: "group.com.randomgenerator.app")
    }
    
    @Published var selectedWidgetType: String
    
    // Numbers settings
    @Published var minValueText: String
    @Published var maxValueText: String
    @Published var numberCount: Int
    
    // Coin settings
    @Published var coinCount: Int
    
    // Preview data
    @Published var previewNumbers: [Int] = []
    @Published var previewCoinResults: [Bool] = []
    
    init() {
        // First, initialize all stored properties with default values
        self.selectedWidgetType = WidgetType.numbers.rawValue
        self.minValueText = "1"
        self.maxValueText = "100"
        self.numberCount = 3
        self.coinCount = 3
        
        // Now that all properties are initialized, we can use 'self'
        // to load values from UserDefaults if available
        if let defaults = UserDefaults(suiteName: "group.com.randomgenerator.app") {
            if let widgetType = defaults.string(forKey: "widgetType") {
                self.selectedWidgetType = widgetType
            }
            
            let minValue = defaults.integer(forKey: "minValue")
            if minValue != 0 {
                self.minValueText = String(minValue)
            }
            
            let maxValue = defaults.integer(forKey: "maxValue")
            if maxValue != 0 {
                self.maxValueText = String(maxValue)
            }
            
            let numberCount = defaults.integer(forKey: "numberCount")
            if numberCount != 0 {
                self.numberCount = numberCount
            }
            
            let coinCount = defaults.integer(forKey: "coinCount")
            if coinCount != 0 {
                self.coinCount = coinCount
            }
        }
        
        // Generate initial preview data
        updatePreview()
    }
    
    func saveWidgetType() {
        userDefaults?.set(selectedWidgetType, forKey: "widgetType")
        updatePreview()
    }
    
    func saveConfiguration() {
        // Save numbers settings
        if let minValue = Int(minValueText) {
            userDefaults?.set(minValue, forKey: "minValue")
        }
        
        if let maxValue = Int(maxValueText) {
            userDefaults?.set(maxValue, forKey: "maxValue")
        }
        
        userDefaults?.set(numberCount, forKey: "numberCount")
        
        // Save coin settings
        userDefaults?.set(coinCount, forKey: "coinCount")
        
        // Reload widgets if WidgetCenter is available
        #if !PREVIEW
        WidgetCenter.shared.reloadAllTimelines()
        #endif
        
        // Update preview
        updatePreview()
    }
    
    func updatePreview() {
        switch selectedWidgetType {
        case WidgetType.numbers.rawValue:
            let min = Int(minValueText) ?? 1
            let max = Int(maxValueText) ?? 100
            previewNumbers = (1...numberCount).map { _ in Int.random(in: min...max) }
            previewCoinResults = []
            
        case WidgetType.coins.rawValue:
            previewCoinResults = (1...coinCount).map { _ in Bool.random() }
            previewNumbers = []
            
        default:
            // Default to numbers if unknown type
            let min = Int(minValueText) ?? 1
            let max = Int(maxValueText) ?? 100
            previewNumbers = (1...numberCount).map { _ in Int.random(in: min...max) }
            previewCoinResults = []
        }
    }
}
