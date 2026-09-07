import SnapKit
import UIKit

public let CRColorMaster = UIColor(red: 49.0 / 255.0, green: 51.0 / 255.0, blue: 64.0 / 255.0, alpha: 1)
public typealias CRLineViewSelectChangeBlock = (CRLineView, Bool) -> Void

open class CRLineView: UIView {
    public var lineView = UIView()
    public var selected = false {
        didSet {
            selectChangeBlock?(self, selected)
        }
    }

    public var underlineColorNormal = CRColorMaster
    public var underlineColorSelected = CRColorMaster
    public var underlineColorFilled = CRColorMaster
    public var selectChangeBlock: CRLineViewSelectChangeBlock?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        createUI()
    }

    private func createUI() {
        let separatorHeight: CGFloat = 4
        lineView.backgroundColor = underlineColorNormal
        lineView.layer.cornerRadius = separatorHeight / 2
        addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.height.equalTo(separatorHeight)
            make.left.right.bottom.equalToSuperview()
        }

        lineView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        lineView.layer.shadowOpacity = 1
        lineView.layer.shadowOffset = CGSize(width: 0, height: 2)
        lineView.layer.shadowRadius = 4
    }
}
