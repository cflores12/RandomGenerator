import SwiftUI

struct CoinFlipperView: View {
    @StateObject private var viewModel = CoinViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            // Coin configuration
            VStack(alignment: .leading, spacing: 5) {
                Text("Number of Coins")
                    .font(.headline)
                
                Stepper("\(viewModel.numberOfFlips) coin\(viewModel.numberOfFlips > 1 ? "s" : "")", value: $viewModel.numberOfFlips, in: 1...10)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }
            
            // Flip button
            Button(action: viewModel.flipCoins) {
                Text("Flip Coin\(viewModel.numberOfFlips > 1 ? "s" : "")")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            // Results
            if !viewModel.coinResults.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Results:")
                            .font(.headline)
                        
                        Spacer()
                        
                        // Copy button
                        CopyButton(action: viewModel.copyCoinResults, label: "Copy")
                    }
                    
                    // Coin results
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 15) {
                            ForEach(viewModel.coinResults.indices, id: \.self) { index in
                                CoinView(isHeads: viewModel.coinResults[index])
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
                        
                        Text("Heads: \(viewModel.headsCount), Tails: \(viewModel.tailsCount)")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    .padding(.top, 5)
                    
                    // Copy feedback
                    if viewModel.copiedFeedback {
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
}