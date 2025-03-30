import SwiftUI

struct MainView: View {
    @State private var selectedTab = 0
    
    // Define tabs
    private let tabs = [
        TabItem(title: "Numbers"),
        TabItem(title: "Dice"),
        TabItem(title: "Coins")
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Custom top navbar
            NavbarView(selectedTab: $selectedTab, tabs: tabs)
            
            // Content based on selected tab
            ZStack {
                NumberGeneratorView()
                    .opacity(selectedTab == 0 ? 1 : 0)
                    .disabled(selectedTab != 0)
                
                DiceRollerView()
                    .opacity(selectedTab == 1 ? 1 : 0)
                    .disabled(selectedTab != 1)
                
                CoinFlipperView()
                    .opacity(selectedTab == 2 ? 1 : 0)
                    .disabled(selectedTab != 2)
                //WidgetConfigView()
                //    .opacity(selectedTab == 3 ? 1 : 0)
                //    .disabled(selectedTab != 3)
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
