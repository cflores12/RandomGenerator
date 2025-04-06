import SwiftUI
import WidgetKit

// This extension provides compatibility across different iOS versions
extension View {
    @ViewBuilder
    func widgetBackgroundModifier() -> some View {
        if #available(iOS 17.0, *) {
            self.containerBackground(for: .widget) {
                Color(UIColor.systemBackground)
            }
        } else {
            self.background(Color(UIColor.systemBackground))
        }
    }
}
