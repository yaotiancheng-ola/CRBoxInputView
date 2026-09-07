import SnapKit
import UIKit

@objcMembers
open class CRSecrectImageView: UIView {
    private let lockImageView = UIImageView()

    public var image: UIImage? {
        didSet { lockImageView.image = image }
    }

    public var imageWidth: CGFloat = 0 {
        didSet {
            lockImageView.snp.updateConstraints { make in
                make.width.equalTo(imageWidth)
            }
        }
    }

    public var imageHeight: CGFloat = 0 {
        didSet {
            lockImageView.snp.updateConstraints { make in
                make.height.equalTo(imageHeight)
            }
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        createUI()
    }

    private func createUI() {
        lockImageView.image = UIImage(named: "smallLock")
        addSubview(lockImageView)
        lockImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(23)
            make.height.equalTo(27)
        }
    }
}
