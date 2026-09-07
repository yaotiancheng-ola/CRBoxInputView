import UIKit

@objcMembers
open class CRBoxFlowLayout: UICollectionViewFlowLayout {
    /// Whether the gaps between items should be calculated automatically. Default: `true`.
    public var ifNeedEqualGap = true
    public var itemNum = 1
    /// Minimum line spacing used by the automatic calculation. Default: `10`.
    public var minLineSpacing = 10

    public override init() {
        super.init()
        initializeParameters()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializeParameters()
    }

    private func initializeParameters() {
        scrollDirection = .horizontal
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        sectionInset = .zero
    }

    open override func prepare() {
        if ifNeedEqualGap {
            autoCalucateLineSpacing()
        }
        super.prepare()
    }

    /// Keeps the original public selector, including its historical spelling.
    open func autoCalucateLineSpacing() {
        guard itemNum > 1, let collectionView else {
            minimumLineSpacing = 0
            return
        }

        let availableWidth = collectionView.frame.width
            - CGFloat(itemNum) * itemSize.width
            - collectionView.contentInset.left
            - collectionView.contentInset.right
        minimumLineSpacing = floor(availableWidth / CGFloat(itemNum - 1))
        if minimumLineSpacing < CGFloat(minLineSpacing) {
            minimumLineSpacing = CGFloat(minLineSpacing)
        }
    }
}
