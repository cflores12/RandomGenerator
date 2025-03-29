import SwiftUI

struct NavbarView: View {
    @Binding var selectedTab: Int
    let tabs: [TabItem]
    
    var body: some View {
        VStack(spacing: 0) {
            // App title
            Text("Random Generator")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.top, 10)
            
            // Tab buttons with underline for selected tab
            HStack(spacing: 0) {
                ForEach(0..<tabs.count, id: \.self) { index in
                    Button(action: {
                        selectedTab = index
                    }) {
                        VStack(spacing: 0) {
                            Text(tabs[index].title)
                                .font(.system(size: 16, weight: selectedTab == index ? .semibold : .regular))
                                .foregroundColor(.white)
                                .padding(.vertical, 12)
                            
                            // Underline for selected tab
                            Rectangle()
                                .frame(height: 3)
                                .foregroundColor(selectedTab == index ? .white : .clear)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal)
            .background(Color.blue)
        }
        .background(Color.blue)
        .shadow(color: Color.gray.opacity(0.3), radius: 3, x: 0, y: 2)
    }
}
