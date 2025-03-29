import SwiftUI

struct NumberGeneratorView: View {
    @StateObject private var viewModel = NumberGeneratorViewModel()
    
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
            if !viewModel.generatedNumbers.isEmpty {
                resultsSection
            }
            
            Spacer()
        }
        .padding()
        .alert(isPresented: $viewModel.showError) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.errorMessage),
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
                    TextField("Min", text: $viewModel.minValueText)
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
                    TextField("Max", text: $viewModel.maxValueText)
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
                TextField("How many numbers to generate", text: $viewModel.countText)
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }
        }
    }
    
    private var generateButton: some View {
        Button(action: viewModel.generateRandomNumbers) {
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
                CopyButton(action: viewModel.copyAllNumbers, label: "Copy All")
            }
            
            // Numbers grid
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(viewModel.generatedNumbers.indices, id: \.self) { index in
                        let number = viewModel.generatedNumbers[index]
                        NumberBox(
                            number: number,
                            isHighlighted: viewModel.copiedFeedback == "\(number)",
                            onTap: { viewModel.copySingleNumber(number) }
                        )
                    }
                }
                .padding()
            }
            .frame(maxHeight: 300)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            
            // Feedback for copying all numbers
            if viewModel.copiedFeedback == "all" {
                Text("All numbers copied to clipboard!")
                    .font(.footnote)
                    .foregroundColor(.green)
                    .padding(.top, 5)
            }
        }
    }
}