import SwiftUI

struct CopyButton: View {
    let action: () -> Void
    let label: String
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "doc.on.doc")
                Text(label)
            }
            .font(.system(size: 14))
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Color.blue.opacity(0.1))
            .foregroundColor(.blue)
            .cornerRadius(6)
        }
    }
}
