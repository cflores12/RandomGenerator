import SwiftUI

struct DiceRollerView: View {
    @StateObject private var viewModel = DiceViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            // Dice configuration
            VStack(spacing: 15) {
                // Number of dice
                VStack(alignment: .leading, spacing: 5) {
                    Text("Number of Dice")
                        .font(.headline)
                    
                    Stepper("\(viewModel.diceCount) dice", value: $viewModel.diceCount, in: 1...10)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
                
                // Dice type
                VStack(alignment: .leading, spacing: 5) {
                    Text("Dice Type")
                        .font(.headline)
                    
                    Picker("Select dice type", selection: $viewModel.diceType) {
                        ForEach(viewModel.diceTypes, id: \.self) { type in
                            Text("d\(type)").tag(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.vertical, 8)
                }
            }
            
            // Roll button
            Button(action: viewModel.rollDice) {
                Text("Roll Dice")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            // Results
            if !viewModel.diceResults.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Results:")
                            .font(.headline)
                        
                        Spacer()
                        
                        // Copy button
                        CopyButton(action: viewModel.copyDiceResults, label: "Copy")
                    }
                    
                    // Dice results
                    ScrollView {
                        VStack(spacing: 15) {
                            // Dice icons
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 70))], spacing: 10) {
                                ForEach(viewModel.diceResults, id: \.self) { value in
                                    DiceBox(value: value)
                                }
                            }
                            
                            // Total
                            HStack {
                                Text("Total:")
                                    .font(.headline)
                                
                                Spacer()
                                
                                Text("\(viewModel.totalValue)")
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
                    if viewModel.copiedFeedback {
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
}