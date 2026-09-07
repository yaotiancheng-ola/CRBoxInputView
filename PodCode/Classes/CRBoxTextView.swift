import UIKit

@objcMembers
open class CRBoxTextView: UITextField {
    /// Disable copy, paste, and the edit menu, matching the Objective-C implementation.
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        false
    }
}
