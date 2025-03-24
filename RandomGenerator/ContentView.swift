//
//  ContentView.swift
//  RandomGenerator
//
//  Created by chanales flores on 3/16/25.
//

import SwiftUI
import UIKit

// Separate component for the number box
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

struct ContentView: View {
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
        NavigationView {
            VStack(spacing: 20) {
                // Title
                Text("Random Number Generator")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 10)
                
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
            .navigationBarTitle("", displayMode: .inline)
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

#Preview {
    ContentView()
}
