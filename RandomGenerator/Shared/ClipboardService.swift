import UIKit

struct ClipboardService {
    static func copyToClipboard(_ string: String) {
        UIPasteboard.general.string = string
    }
}
