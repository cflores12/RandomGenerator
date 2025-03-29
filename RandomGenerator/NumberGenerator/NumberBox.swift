import SwiftUI

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