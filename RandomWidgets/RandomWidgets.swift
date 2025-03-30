import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> RandomEntry {
        RandomEntry(date: Date(), widgetType: .numbers, numbers: [42, 17, 23], diceResults: [], coinResults: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (RandomEntry) -> ()) {
        let entry = RandomEntry(date: Date(), widgetType: .numbers, numbers: [7, 13, 42], diceResults: [], coinResults: [])
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [RandomEntry] = []
        let currentDate = Date()
        
        // Get the widget configuration from UserDefaults
        let widgetType = WidgetType(rawValue: UserDefaults(suiteName: "group.com.randomgenerator.app")?.string(forKey: "widgetType") ?? "numbers") ?? .numbers
        
        // Generate appropriate random data based on widget type
        switch widgetType {
        case .numbers:
            let min = UserDefaults(suiteName: "group.com.randomgenerator.app")?.integer(forKey: "minValue") ?? 1
            let max = UserDefaults(suiteName: "group.com.randomgenerator.app")?.integer(forKey: "maxValue") ?? 100
            let count = UserDefaults(suiteName: "group.com.randomgenerator.app")?.integer(forKey: "numberCount") ?? 3
            
            let numbers = (1...count).map { _ in Int.random(in: min...max) }
            entries.append(RandomEntry(date: currentDate, widgetType: .numbers, numbers: numbers, diceResults: [], coinResults: []))
            
        case .dice:
            let diceCount = UserDefaults(suiteName: "group.com.randomgenerator.app")?.integer(forKey: "diceCount") ?? 2
            let diceType = UserDefaults(suiteName: "group.com.randomgenerator.app")?.integer(forKey: "diceType") ?? 6
            
            let diceResults = (1...diceCount).map { _ in Int.random(in: 1...diceType) }
            entries.append(RandomEntry(date: currentDate, widgetType: .dice, numbers: [], diceResults: diceResults, coinResults: []))
            
        case .coins:
            let coinCount = UserDefaults(suiteName: "group.com.randomgenerator.app")?.integer(forKey: "coinCount") ?? 3
            
            let coinResults = (1...coinCount).map { _ in Bool.random() }
            entries.append(RandomEntry(date: currentDate, widgetType: .coins, numbers: [], diceResults: [], coinResults: coinResults))
        }
        
        // Create a timeline with one entry that refreshes every 15 minutes
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!
        let timeline = Timeline(entries: entries, policy: .after(refreshDate))
        completion(timeline)
    }
}

struct RandomEntry: TimelineEntry {
    let date: Date
    let widgetType: WidgetType
    let numbers: [Int]
    let diceResults: [Int]
    let coinResults: [Bool]
}

enum WidgetType: String {
    case numbers
    case dice
    case coins
}

struct RandomWidgetsEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        ZStack {
            Color(UIColor.systemBackground)
            
            switch entry.widgetType {
            case .numbers:
                NumbersWidgetView(numbers: entry.numbers, family: family)
            case .dice:
                DiceWidgetView(diceResults: entry.diceResults, family: family)
            case .coins:
                CoinsWidgetView(coinResults: entry.coinResults, family: family)
            }
        }
    }
}

struct NumbersWidgetView: View {
    let numbers: [Int]
    let family: WidgetFamily
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Random Numbers")
                .font(.headline)
                .foregroundColor(.blue)
            
            if family == .systemSmall {
                // Show fewer numbers on small widget
                VStack(spacing: 4) {
                    ForEach(numbers.prefix(3), id: \.self) { number in
                        Text("\(number)")
                            .font(.system(size: 18, weight: .semibold))
                            .padding(.vertical, 2)
                    }
                }
            } else {
                // Show in a grid for medium and large widgets
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 8) {
                    ForEach(numbers, id: \.self) { number in
                        Text("\(number)")
                            .font(.system(size: 18, weight: .semibold))
                            .frame(minWidth: 50, minHeight: 40)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
            }
            
            Text("Tap to refresh")
                .font(.caption2)
                .foregroundColor(.gray)
        }
        .padding()
    }
}

struct DiceWidgetView: View {
    let diceResults: [Int]
    let family: WidgetFamily
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Dice Roll")
                .font(.headline)
                .foregroundColor(.blue)
            
            if family == .systemSmall {
                // Show dice in a compact format for small widget
                HStack(spacing: 8) {
                    ForEach(diceResults.prefix(2), id: \.self) { value in
                        Text("\(value)")
                            .font(.system(size: 24, weight: .bold))
                            .frame(width: 40, height: 40)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
                
                if diceResults.count > 0 {
                    Text("Total: \(diceResults.reduce(0, +))")
                        .font(.caption)
                        .fontWeight(.medium)
                }
            } else {
                // Show dice in a grid for medium and large widgets
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))], spacing: 8) {
                    ForEach(diceResults, id: \.self) { value in
                        Text("\(value)")
                            .font(.system(size: 20, weight: .bold))
                            .frame(width: 50, height: 50)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
                
                if diceResults.count > 0 {
                    Text("Total: \(diceResults.reduce(0, +))")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
            }
            
            Text("Tap to refresh")
                .font(.caption2)
                .foregroundColor(.gray)
        }
        .padding()
    }
}

struct CoinsWidgetView: View {
    let coinResults: [Bool]
    let family: WidgetFamily
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Coin Flips")
                .font(.headline)
                .foregroundColor(.blue)
            
            if family == .systemSmall {
                // Show coins in a compact format for small widget
                HStack(spacing: 8) {
                    ForEach(coinResults.prefix(3).indices, id: \.self) { index in
                        Text(coinResults[index] ? "H" : "T")
                            .font(.system(size: 18, weight: .bold))
                            .frame(width: 30, height: 30)
                            .background(coinResults[index] ? Color.yellow.opacity(0.3) : Color.gray.opacity(0.3))
                            .clipShape(Circle())
                    }
                }
                
                if coinResults.count > 0 {
                    let headsCount = coinResults.filter { $0 }.count
                    Text("H: \(headsCount), T: \(coinResults.count - headsCount)")
                        .font(.caption)
                }
            } else {
                // Show coins in a grid for medium and large widgets
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))], spacing: 8) {
                    ForEach(coinResults.indices, id: \.self) { index in
                        Text(coinResults[index] ? "H" : "T")
                            .font(.system(size: 18, weight: .bold))
                            .frame(width: 40, height: 40)
                            .background(coinResults[index] ? Color.yellow.opacity(0.3) : Color.gray.opacity(0.3))
                            .clipShape(Circle())
                    }
                }
                
                if coinResults.count > 0 {
                    let headsCount = coinResults.filter { $0 }.count
                    Text("Heads: \(headsCount), Tails: \(coinResults.count - headsCount)")
                        .font(.subheadline)
                }
            }
            
            Text("Tap to refresh")
                .font(.caption2)
                .foregroundColor(.gray)
        }
        .padding()
    }
}

struct RandomWidgets: Widget {
    let kind: String = "RandomWidgets"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            RandomWidgetsEntryView(entry: entry)
        }
        .configurationDisplayName("Random Generator")
        .description("Display random numbers, dice rolls, or coin flips.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct RandomWidgets_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Numbers widget previews
            RandomWidgetsEntryView(entry: RandomEntry(
                date: Date(),
                widgetType: .numbers,
                numbers: [7, 42, 13, 56, 29],
                diceResults: [],
                coinResults: []
            ))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .previewDisplayName("Numbers (Small)")
            
            RandomWidgetsEntryView(entry: RandomEntry(
                date: Date(),
                widgetType: .numbers,
                numbers: [7, 42, 13, 56, 29, 88, 3, 17],
                diceResults: [],
                coinResults: []
            ))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .previewDisplayName("Numbers (Medium)")
            
            // Dice widget previews
            RandomWidgetsEntryView(entry: RandomEntry(
                date: Date(),
                widgetType: .dice,
                numbers: [],
                diceResults: [4, 6],
                coinResults: []
            ))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .previewDisplayName("Dice (Small)")
            
            RandomWidgetsEntryView(entry: RandomEntry(
                date: Date(),
                widgetType: .dice,
                numbers: [],
                diceResults: [4, 6, 2, 5, 1],
                coinResults: []
            ))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .previewDisplayName("Dice (Medium)")
            
            // Coins widget previews
            RandomWidgetsEntryView(entry: RandomEntry(
                date: Date(),
                widgetType: .coins,
                numbers: [],
                diceResults: [],
                coinResults: [true, false, true]
            ))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .previewDisplayName("Coins (Small)")
            
            RandomWidgetsEntryView(entry: RandomEntry(
                date: Date(),
                widgetType: .coins,
                numbers: [],
                diceResults: [],
                coinResults: [true, false, true, false, true, false]
            ))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .previewDisplayName("Coins (Medium)")
        }
    }
}
