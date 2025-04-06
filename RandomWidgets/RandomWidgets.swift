import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    // Use a computed property to safely access UserDefaults
    private var userDefaults: UserDefaults? {
        UserDefaults(suiteName: "group.com.randomgenerator.app")
    }
    
    func placeholder(in context: Context) -> RandomEntry {
        // Return a simple placeholder entry
        RandomEntry(date: Date(), widgetType: .numbers, numbers: [42, 17, 23], coinResults: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (RandomEntry) -> ()) {
        // Create a snapshot entry with sample data
        let entry = RandomEntry(date: Date(), widgetType: .numbers, numbers: [7, 13, 42], coinResults: [])
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [RandomEntry] = []
        let currentDate = Date()
        
        // Get the widget configuration from UserDefaults
        let widgetTypeString = userDefaults?.string(forKey: "widgetType") ?? WidgetType.numbers.rawValue
        let widgetType = WidgetType(rawValue: widgetTypeString) ?? .numbers
        
        // Generate appropriate random data based on widget type
        switch widgetType {
        case .numbers:
            let min = userDefaults?.integer(forKey: "minValue") ?? 1
            let max = userDefaults?.integer(forKey: "maxValue") ?? 100
            let count = userDefaults?.integer(forKey: "numberCount") ?? 3
            
            let numbers = (1...count).map { _ in Int.random(in: min...max) }
            entries.append(RandomEntry(date: currentDate, widgetType: .numbers, numbers: numbers, coinResults: []))
            
        case .coins:
            let coinCount = userDefaults?.integer(forKey: "coinCount") ?? 3
            
            let coinResults = (1...coinCount).map { _ in Bool.random() }
            entries.append(RandomEntry(date: currentDate, widgetType: .coins, numbers: [], coinResults: coinResults))
            
        default:
            // Default to numbers if unknown type
            let min = userDefaults?.integer(forKey: "minValue") ?? 1
            let max = userDefaults?.integer(forKey: "maxValue") ?? 100
            let count = userDefaults?.integer(forKey: "numberCount") ?? 3
            
            let numbers = (1...count).map { _ in Int.random(in: min...max) }
            entries.append(RandomEntry(date: currentDate, widgetType: .numbers, numbers: numbers, coinResults: []))
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
    let coinResults: [Bool]
}

struct RandomWidgetsEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        VStack {
            switch entry.widgetType {
            case .numbers:
                NumbersWidgetView(numbers: entry.numbers, family: family)
            case .coins:
                CoinsWidgetView(coinResults: entry.coinResults, family: family)
            default:
                NumbersWidgetView(numbers: entry.numbers, family: family)
            }
        }
        .widgetBackgroundModifier() // Use our custom modifier here
    }
}

struct NumbersWidgetView: View {
    let numbers: [Int]
    let family: WidgetFamily
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Numbers")
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
                        if index < coinResults.count {
                            Text(coinResults[index] ? "H" : "T")
                                .font(.system(size: 18, weight: .bold))
                                .frame(width: 30, height: 30)
                                .background(coinResults[index] ? Color.yellow.opacity(0.3) : Color.gray.opacity(0.3))
                                .clipShape(Circle())
                        }
                    }
                }
                
                if !coinResults.isEmpty {
                    let headsCount = coinResults.filter { $0 }.count
                    Text("H: \(headsCount), T: \(coinResults.count - headsCount)")
                        .font(.caption)
                }
            } else {
                // Show coins in a grid for medium and large widgets
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))], spacing: 8) {
                    ForEach(coinResults.indices, id: \.self) { index in
                        if index < coinResults.count {
                            Text(coinResults[index] ? "H" : "T")
                                .font(.system(size: 18, weight: .bold))
                                .frame(width: 40, height: 40)
                                .background(coinResults[index] ? Color.yellow.opacity(0.3) : Color.gray.opacity(0.3))
                                .clipShape(Circle())
                        }
                    }
                }
                
                if !coinResults.isEmpty {
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
        .description("Display random numbers or coin flips.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// Create a separate preview provider with static data
struct RandomWidgets_Previews: PreviewProvider {
    static var previews: some View {
        // Numbers widget previews
        RandomWidgetsEntryView(entry: RandomEntry(
            date: Date(),
            widgetType: .numbers,
            numbers: [7, 42, 13, 56, 29],
            coinResults: []
        ))
        .previewContext(WidgetPreviewContext(family: .systemSmall))
        .previewDisplayName("Numbers (Small)")
        
        RandomWidgetsEntryView(entry: RandomEntry(
            date: Date(),
            widgetType: .numbers,
            numbers: [7, 42, 13, 56, 29, 88, 3, 17],
            coinResults: []
        ))
        .previewContext(WidgetPreviewContext(family: .systemMedium))
        .previewDisplayName("Numbers (Medium)")
        
        // Coins widget previews
        RandomWidgetsEntryView(entry: RandomEntry(
            date: Date(),
            widgetType: .coins,
            numbers: [],
            coinResults: [true, false, true]
        ))
        .previewContext(WidgetPreviewContext(family: .systemSmall))
        .previewDisplayName("Coins (Small)")
        
        RandomWidgetsEntryView(entry: RandomEntry(
            date: Date(),
            widgetType: .coins,
            numbers: [],
            coinResults: [true, false, true, false, true, false]
        ))
        .previewContext(WidgetPreviewContext(family: .systemMedium))
        .previewDisplayName("Coins (Medium)")
    }
}
