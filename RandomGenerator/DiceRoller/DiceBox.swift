import SwiftUI

struct DiceBox: View {
    let value: Int
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.blue.opacity(0.1))
                .frame(width: 60, height: 60)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.blue, lineWidth: 1)
                )
            
            Text("\(value)")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.blue)
        }
    }
}