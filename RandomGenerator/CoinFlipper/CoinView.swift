import SwiftUI

struct CoinView: View {
    let isHeads: Bool
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(isHeads ? Color.yellow.opacity(0.3) : Color.gray.opacity(0.3))
                    .frame(width: 70, height: 70)
                    .overlay(
                        Circle()
                            .stroke(isHeads ? Color.yellow : Color.gray, lineWidth: 2)
                    )
                
                Text(isHeads ? "H" : "T")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(isHeads ? .orange : .gray)
            }
            
            Text(isHeads ? "Heads" : "Tails")
                .font(.caption)
                .foregroundColor(isHeads ? .orange : .gray)
        }
    }
}