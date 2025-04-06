import SwiftUI

struct WidgetConfigView: View {
    @StateObject private var viewModel = WidgetConfigViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Widget Type")) {
                    Picker("Type", selection: $viewModel.selectedWidgetType) {
                        Text("Numbers").tag(WidgetType.numbers.rawValue)
                        Text("Coins").tag(WidgetType.coins.rawValue)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: viewModel.selectedWidgetType) { _ in
                        viewModel.saveWidgetType()
                    }
                }
                
                if viewModel.selectedWidgetType == WidgetType.numbers.rawValue {
                    Section(header: Text("Number Settings")) {
                        HStack {
                            Text("Min Value")
                            Spacer()
                            TextField("Min", text: $viewModel.minValueText)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                                .frame(width: 100)
                        }
                        
                        HStack {
                            Text("Max Value")
                            Spacer()
                            TextField("Max", text: $viewModel.maxValueText)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                                .frame(width: 100)
                        }
                        
                        Stepper("Count: \(viewModel.numberCount)", value: $viewModel.numberCount, in: 1...10)
                    }
                } else if viewModel.selectedWidgetType == WidgetType.coins.rawValue {
                    Section(header: Text("Coin Settings")) {
                        Stepper("Number of Coins: \(viewModel.coinCount)", value: $viewModel.coinCount, in: 1...10)
                    }
                }
                
                Section {
                    Button("Save Widget Configuration") {
                        viewModel.saveConfiguration()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.blue)
                }
                
                Section(header: Text("Widget Preview")) {
                    widgetPreview
                        .frame(height: 150)
                        .frame(maxWidth: .infinity)
                }
                
                Section(header: Text("Instructions")) {
                    Text("After saving your configuration, add the Random Generator widget to your home screen. The widget will display random values based on your settings.")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("Widget Configuration")
        }
    }
    
    var widgetPreview: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(UIColor.systemBackground))
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
            
            if viewModel.selectedWidgetType == WidgetType.numbers.rawValue {
                VStack {
                    Text("Random Numbers")
                        .font(.headline)
                        .foregroundColor(.blue)
                    
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 8) {
                        ForEach(viewModel.previewNumbers, id: \.self) { number in
                            Text("\(number)")
                                .font(.system(size: 18, weight: .semibold))
                                .frame(minWidth: 50, minHeight: 40)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                }
                .padding()
            } else if viewModel.selectedWidgetType == WidgetType.coins.rawValue {
                VStack {
                    Text("Coin Flips")
                        .font(.headline)
                        .foregroundColor(.blue)
                    
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))], spacing: 8) {
                        ForEach(viewModel.previewCoinResults.indices, id: \.self) { index in
                            Text(viewModel.previewCoinResults[index] ? "H" : "T")
                                .font(.system(size: 18, weight: .bold))
                                .frame(width: 40, height: 40)
                                .background(viewModel.previewCoinResults[index] ? Color.yellow.opacity(0.3) : Color.gray.opacity(0.3))
                                .clipShape(Circle())
                        }
                    }
                    
                    if !viewModel.previewCoinResults.isEmpty {
                        let headsCount = viewModel.previewCoinResults.filter { $0 }.count
                        Text("Heads: \(headsCount), Tails: \(viewModel.previewCoinResults.count - headsCount)")
                            .font(.subheadline)
                    }
                }
                .padding()
            }
        }
    }
}

struct WidgetConfigView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetConfigView()
    }
}
