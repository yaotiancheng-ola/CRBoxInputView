enum CRBoxInputModelType: Int {
    case normal
    case placeholder
    case customBox
    case line
    case secretSymbol
    case secretImage
    case secretView
}

final class CRBoxInputModel {
    var name = ""
    var imageName = ""
    var type: CRBoxInputModelType = .normal
}
