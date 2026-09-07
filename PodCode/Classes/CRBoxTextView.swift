import UIKit

open class CRBoxTextView: UITextField {
    /// Disable copy, paste, and the edit menu, matching the original implementation.
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        false
    }
}
