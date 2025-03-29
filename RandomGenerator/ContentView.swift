import SwiftUI
import UIKit

// MARK: - Number Box Component
struct NumberBox: View {
    let number: Int
    let isHighlighted: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Text("\(number)")
                .font(.system(size: 18, weight: .medium))
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(height: 60)
                .background(isHighlighted ? Color.green.opacity(0.2) : Color.blue.opacity(0.1))
                .foregroundColor(.blue)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isHighlighted ? Color.green : Color.blue, lineWidth: 1)
                )
                .overlay(
                    isHighlighted ?
                    Text("Copied!")
                        .font(.system(size: 12))
                        .foregroundColor(.green)
                        .padding(4)
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(4)
                        .position(x: 40, y: 15) : nil
                )
        }
    }
}

// MARK: - Random Number Generator View
struct NumberGeneratorView: View {
    @State private var minValue: String = ""
    @State private var maxValue: String = ""
    @State private var numberOfValues: String = "5"
    @State private var randomNumbers: [Int] = []
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var copiedFeedback: String? = nil
    
    // Grid layout for the boxes
    private let columns = [
        GridItem(.adaptive(minimum: 80), spacing: 10)
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            // Input fields section
            inputFieldsSection
            
            // Generate button
            generateButton
            
            // Results section
            if !randomNumbers.isEmpty {
                resultsSection
            }
            
            Spacer()
        }
        .padding()
        .alert(isPresented: $showError) {
            Alert(
                title: Text("Error"),
                message: Text(errorMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    // MARK: - View Components
    
    private var inputFieldsSection: some View {
        VStack(spacing: 15) {
            // Min and Max on the same row
            HStack(spacing: 15) {
                // Min input
                VStack(alignment: .leading, spacing: 5) {
                    Text("Min")
                        .font(.headline)
                    TextField("Min", text: $minValue)
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
                .frame(maxWidth: .infinity)
                
                // Max input
                VStack(alignment: .leading, spacing: 5) {
                    Text("Max")
                        .font(.headline)
                    TextField("Max", text: $maxValue)
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
                .frame(maxWidth: .infinity)
            }
            
            // Number of values input
            VStack(alignment: .leading, spacing: 5) {
                Text("Number of Values")
                    .font(.headline)
                TextField("How many numbers to generate", text: $numberOfValues)
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }
        }
    }
    
    private var generateButton: some View {
        Button(action: generateRandomNumbers) {
            Text("Generate Random Numbers")
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(10)
        }
    }
    
    private var resultsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Header with copy all button
            HStack {
                Text("Generated Numbers:")
                    .font(.headline)
                
                Spacer()
                
                // Copy All button
                Button(action: copyAllNumbers) {
                    HStack {
                        Image(systemName: "doc.on.doc")
                        Text("Copy All")
                    }
                    .font(.system(size: 14))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.blue.opacity(0.1))
                    .foregroundColor(.blue)
                    .cornerRadius(6)
                }
            }
            
            // Numbers grid
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(randomNumbers.indices, id: \.self) { index in
                        let number = randomNumbers[index]
                        NumberBox(
                            number: number,
                            isHighlighted: copiedFeedback == "\(number)",
                            onTap: { copySingleNumber(number) }
                        )
                    }
                }
                .padding()
            }
            .frame(maxHeight: 300)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            
            // Feedback for copying all numbers
            if copiedFeedback == "all" {
                Text("All numbers copied to clipboard!")
                    .font(.footnote)
                    .foregroundColor(.green)
                    .padding(.top, 5)
            }
        }
    }
    
    // MARK: - Functions
    
    func generateRandomNumbers() {
        // Validate inputs
        guard let min = Int(minValue) else {
            showError(message: "Please enter a valid minimum value")
            return
        }
        
        guard let max = Int(maxValue) else {
            showError(message: "Please enter a valid maximum value")
            return
        }
        
        guard let count = Int(numberOfValues), count > 0 else {
            showError(message: "Please enter a valid number of values to generate")
            return
        }
        
        if min >= max {
            showError(message: "Maximum value must be greater than minimum value")
            return
        }
        
        // Generate random numbers
        randomNumbers = (1...count).map { _ in Int.random(in: min...max) }
        copiedFeedback = nil
    }
    
    func showError(message: String) {
        errorMessage = message
        showError = true
    }
    
    func copyAllNumbers() {
        let numbersText = randomNumbers.map { String($0) }.joined(separator: ", ")
        UIPasteboard.general.string = numbersText
        copiedFeedback = "all"
        
        // Reset the feedback after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if copiedFeedback == "all" {
                copiedFeedback = nil
            }
        }
    }
    
    func copySingleNumber(_ number: Int) {
        UIPasteboard.general.string = String(number)
        copiedFeedback = "\(number)"
        
        // Reset the feedback after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if copiedFeedback == "\(number)" {
                copiedFeedback = nil
            }
        }
    }
}

// MARK: - Dice Roller View
struct DiceRollerView: View {
    @State private var diceCount: Int = 2
    @State private var diceType: Int = 6
    @State private var diceResults: [Int] = []
    @State private var isRolling: Bool = false
    @State private var totalValue: Int = 0
    @State private var copiedFeedback: Bool = false
    
    private let diceTypes = [4, 6, 8, 10, 12, 20, 100]
    
    var body: some View {
        VStack(spacing: 20) {
            // Dice configuration
            VStack(spacing: 15) {
                // Number of dice
                VStack(alignment: .leading, spacing: 5) {
                    Text("Number of Dice")
                        .font(.headline)
                    
                    Stepper("\(diceCount) dice", value: $diceCount, in: 1...10)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
                
                // Dice type
                VStack(alignment: .leading, spacing: 5) {
                    Text("Dice Type")
                        .font(.headline)
                    
                    Picker("Select dice type", selection: $diceType) {
                        ForEach(diceTypes, id: \.self) { type in
                            Text("d\(type)").tag(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.vertical, 8)
                }
            }
            
            // Roll button
            Button(action: rollDice) {
                Text("Roll Dice")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            // Results
            if !diceResults.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Results:")
                            .font(.headline)
                        
                        Spacer()
                        
                        // Copy button
                        Button(action: copyDiceResults) {
                            HStack {
                                Image(systemName: "doc.on.doc")
                                Text("Copy")
                            }
                            .font(.system(size: 14))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.blue.opacity(0.1))
                            .foregroundColor(.blue)
                            .cornerRadius(6)
                        }
                    }
                    
                    // Dice results
                    ScrollView {
                        VStack(spacing: 15) {
                            // Dice icons
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 70))], spacing: 10) {
                                ForEach(diceResults.indices, id: \.self) { index in
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.blue.opacity(0.1))
                                            .frame(width: 60, height: 60)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(Color.blue, lineWidth: 1)
                                            )
                                        
                                        Text("\(diceResults[index])")
                                            .font(.system(size: 20, weight: .bold))
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                            
                            // Total
                            HStack {
                                Text("Total:")
                                    .font(.headline)
                                
                                Spacer()
                                
                                Text("\(totalValue)")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                        }
                        .padding()
                    }
                    .frame(maxHeight: 300)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                    
                    // Copy feedback
                    if copiedFeedback {
                        Text("Dice results copied to clipboard!")
                            .font(.footnote)
                            .foregroundColor(.green)
                            .padding(.top, 5)
                    }
                }
            }
            
            Spacer()
        }
        .padding()
    }
    
    func rollDice() {
        isRolling = true
        
        // Generate random dice rolls
        diceResults = (1...diceCount).map { _ in Int.random(in: 1...diceType) }
        totalValue = diceResults.reduce(0, +)
        copiedFeedback = false
        
        isRolling = false
    }
    
    func copyDiceResults() {
        let resultsText = diceResults.map { String($0) }.joined(separator: ", ") + " (Total: \(totalValue))"
        UIPasteboard.general.string = resultsText
        copiedFeedback = true
        
        // Reset the feedback after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            copiedFeedback = false
        }
    }
}

// MARK: - Coin Flipper View
struct CoinFlipperView: View {
    @State private var coinResults: [Bool] = []
    @State private var numberOfFlips: Int = 1
    @State private var isFlipping: Bool = false
    @State private var copiedFeedback: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Coin configuration
            VStack(alignment: .leading, spacing: 5) {
                Text("Number of Coins")
                    .font(.headline)
                
                Stepper("\(numberOfFlips) coin\(numberOfFlips > 1 ? "s" : "")", value: $numberOfFlips, in: 1...10)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }
            
            // Flip button
            Button(action: flipCoins) {
                Text("Flip Coin\(numberOfFlips > 1 ? "s" : "")")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            // Results
            if !coinResults.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Results:")
                            .font(.headline)
                        
                        Spacer()
                        
                        // Copy button
                        Button(action: copyCoinResults) {
                            HStack {
                                Image(systemName: "doc.on.doc")
                                Text("Copy")
                            }
                            .font(.system(size: 14))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.blue.opacity(0.1))
                            .foregroundColor(.blue)
                            .cornerRadius(6)
                        }
                    }
                    
                    // Coin results
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 15) {
                            ForEach(coinResults.indices, id: \.self) { index in
                                VStack {
                                    ZStack {
                                        Circle()
                                            .fill(coinResults[index] ? Color.yellow.opacity(0.3) : Color.gray.opacity(0.3))
                                            .frame(width: 70, height: 70)
                                            .overlay(
                                                Circle()
                                                    .stroke(coinResults[index] ? Color.yellow : Color.gray, lineWidth: 2)
                                            )
                                        
                                        Text(coinResults[index] ? "H" : "T")
                                            .font(.system(size: 24, weight: .bold))
                                            .foregroundColor(coinResults[index] ? .orange : .gray)
                                    }
                                    
                                    Text(coinResults[index] ? "Heads" : "Tails")
                                        .font(.caption)
                                        .foregroundColor(coinResults[index] ? .orange : .gray)
                                }
                            }
                        }
                        .padding()
                    }
                    .frame(maxHeight: 300)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                    
                    // Summary
                    HStack {
                        Text("Summary:")
                            .font(.headline)
                        
                        Spacer()
                        
                        let headsCount = coinResults.filter { $0 }.count
                        let tailsCount = coinResults.count - headsCount
                        
                        Text("Heads: \(headsCount), Tails: \(tailsCount)")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    .padding(.top, 5)
                    
                    // Copy feedback
                    if copiedFeedback {
                        Text("Coin results copied to clipboard!")
                            .font(.footnote)
                            .foregroundColor(.green)
                            .padding(.top, 5)
                    }
                }
            }
            
            Spacer()
        }
        .padding()
    }
    
    func flipCoins() {
        isFlipping = true
        
        // Generate random coin flips (true = heads, false = tails)
        coinResults = (1...numberOfFlips).map { _ in Bool.random() }
        copiedFeedback = false
        
        isFlipping = false
    }
    
    func copyCoinResults() {
        let headsCount = coinResults.filter { $0 }.count
        let tailsCount = coinResults.count - headsCount
        
        let resultsText = coinResults.map { $0 ? "Heads" : "Tails" }.joined(separator: ", ") +
                         "\nSummary: Heads: \(headsCount), Tails: \(tailsCount)"
        
        UIPasteboard.general.string = resultsText
        copiedFeedback = true
        
        // Reset the feedback after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            copiedFeedback = false
        }
    }
}

// MARK: - Tab Item Model
struct TabItem: Identifiable {
    let id = UUID()
    let title: String
}

// MARK: - Main Content View with Top Navbar
struct ContentView: View {
    @State private var selectedTab = 0
    
    // Define tabs
    private let tabs = [
        TabItem(title: "Numbers"),
        TabItem(title: "Dice"),
        TabItem(title: "Coins")
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Custom top navbar with blue background
            VStack(spacing: 0) {
                // App title
                Text("Random Generator")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.top, 10)
                
                // Tab buttons (text only, no icons)
                HStack(spacing: 0) {
                    ForEach(0..<tabs.count, id: \.self) { index in
                        Button(action: {
                            selectedTab = index
                        }) {
                            Text(tabs[index].title)
                                .font(.system(size: 16, weight: selectedTab == index ? .semibold : .regular))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(selectedTab == index ? Color.white.opacity(0.2) : Color.clear)
                                .foregroundColor(.white)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        if index < tabs.count - 1 {
                            Divider()
                                .frame(height: 30)
                                .background(Color.white.opacity(0.3))
                        }
                    }
                }
                .padding(.horizontal)
                .background(Color.blue)
            }
            .background(Color.blue)
            .shadow(color: Color.gray.opacity(0.3), radius: 3, x: 0, y: 2)
            
            // Content based on selected tab
            ZStack {
                NumberGeneratorView()
                    .opacity(selectedTab == 0 ? 1 : 0)
                    .disabled(selectedTab != 0)
                
                DiceRollerView()
                    .opacity(selectedTab == 1 ? 1 : 0)
                    .disabled(selectedTab != 1)
                
                CoinFlipperView()
                    .opacity(selectedTab == 2 ? 1 : 0)
                    .disabled(selectedTab != 2)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

#Preview {
    ContentView()
}
