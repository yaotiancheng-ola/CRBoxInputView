import Foundation

enum CRBoxInputModelType: Int {
    case normal
    case placeholder
    case customBox
    case line
    case secretSymbol
    case secretImage
    case secretView
}

final class CRBoxInputModel: NSObject {
    var name = ""
    var imageName = ""
    var type: CRBoxInputModelType = .normal
}
