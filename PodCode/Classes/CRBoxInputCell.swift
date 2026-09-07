import SnapKit
import UIKit

public let CRBoxCursoryAnimationKey = "CRBoxCursoryAnimationKey"
public let CRBoxInputCellID = "CRBoxInputCellID"

@objcMembers
open class CRBoxInputCell: UICollectionViewCell {
    public var cursorView = UIView()
    public var ifNeedCursor = true
    public var boxInputCellProperty = CRBoxInputCellProperty() {
        didSet { applyCellProperty() }
    }

    private let valueLabel = UILabel()
    private var customSecurityView: UIView?
    private var lineView: CRLineView?
    private var selectedStorage = false

    private lazy var opacityAnimation: CABasicAnimation = {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 1.0
        animation.toValue = 0.0
        animation.duration = 0.9
        animation.repeatCount = .greatestFiniteMagnitude
        animation.isRemovedOnCompletion = true
        animation.fillMode = .forwards
        animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        return animation
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        createBaseUI()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        createBaseUI()
    }

    private func createBaseUI() {
        isUserInteractionEnabled = false

        valueLabel.font = .systemFont(ofSize: 38)
        contentView.addSubview(valueLabel)
        valueLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        contentView.addSubview(cursorView)
        cursorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(0)
            make.height.equalTo(0)
        }

        boxInputCellProperty = CRBoxInputCellProperty()
    }

    private func loadValueLabelData() {
        valueLabel.isHidden = false
        hideCustomSecurityView()

        let defaultTextConfig = { [weak self] in
            guard let self else { return }
            self.valueLabel.font = self.boxInputCellProperty.cellFont
            self.valueLabel.textColor = self.boxInputCellProperty.cellTextColor
        }
        let placeholderTextConfig = { [weak self] in
            guard let self else { return }
            self.valueLabel.font = self.boxInputCellProperty.cellPlaceholderFont
            self.valueLabel.textColor = self.boxInputCellProperty.cellPlaceholderTextColor
        }

        if !boxInputCellProperty.originValue.isEmpty {
            if boxInputCellProperty.ifShowSecurity {
                switch boxInputCellProperty.securityType {
                case .symbol:
                    valueLabel.text = boxInputCellProperty.securitySymbol
                case .customView:
                    valueLabel.isHidden = true
                    showCustomSecurityView()
                }
            } else {
                valueLabel.text = boxInputCellProperty.originValue
            }
            defaultTextConfig()
        } else if let placeholder = boxInputCellProperty.cellPlaceholderText, !placeholder.isEmpty {
            valueLabel.text = placeholder
            placeholderTextConfig()
        } else {
            valueLabel.text = ""
            defaultTextConfig()
        }
    }

    private func showCustomSecurityView() {
        if customSecurityView == nil {
            customSecurityView = createCustomSecurityView()
        }
        guard let customSecurityView else { return }
        if customSecurityView.superview == nil {
            contentView.addSubview(customSecurityView)
            customSecurityView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        customSecurityView.alpha = 1
    }

    private func hideCustomSecurityView() {
        customSecurityView?.alpha = 0
    }

    open override var isSelected: Bool {
        get { selectedStorage }
        set {
            selectedStorage = newValue
            updateSelectionAppearance()
        }
    }

    private func updateSelectionAppearance() {
        if isSelected {
            layer.borderColor = boxInputCellProperty.cellBorderColorSelected.cgColor
            backgroundColor = boxInputCellProperty.cellBgColorSelected
        } else {
            let hasFill = !(valueLabel.text ?? "").isEmpty
            let borderColor = hasFill
                ? boxInputCellProperty.cellBorderColorFilled ?? boxInputCellProperty.cellBorderColorNormal
                : boxInputCellProperty.cellBorderColorNormal
            let fillColor = hasFill
                ? boxInputCellProperty.cellBgColorFilled ?? boxInputCellProperty.cellBgColorNormal
                : boxInputCellProperty.cellBgColorNormal
            layer.borderColor = borderColor.cgColor
            backgroundColor = fillColor
        }

        if let lineView {
            if !isSelected {
                lineView.lineView.backgroundColor = boxInputCellProperty.originValue.isEmpty
                    ? lineView.underlineColorNormal
                    : lineView.underlineColorFilled
            } else {
                lineView.lineView.backgroundColor = lineView.underlineColorSelected
            }
            lineView.selected = isSelected
        }

        if ifNeedCursor && isSelected {
            cursorView.isHidden = false
            cursorView.layer.add(opacityAnimation, forKey: CRBoxCursoryAnimationKey)
        } else {
            cursorView.isHidden = true
            cursorView.layer.removeAnimation(forKey: CRBoxCursoryAnimationKey)
        }
    }

    private func applyCellProperty() {
        cursorView.backgroundColor = boxInputCellProperty.cellCursorColor
        cursorView.snp.updateConstraints { make in
            make.width.equalTo(boxInputCellProperty.cellCursorWidth)
            make.height.equalTo(boxInputCellProperty.cellCursorHeight)
        }
        layer.cornerRadius = boxInputCellProperty.cornerRadius
        layer.borderWidth = boxInputCellProperty.borderWidth
        loadValueLabelData()
    }

    @available(*, deprecated, message: "Please use customSecurityViewBlock in CRBoxInputCellProperty.")
    open func createCustomSecurityView() -> UIView {
        boxInputCellProperty.customSecurityViewBlock()
    }

    open override func layoutSubviews() {
        if boxInputCellProperty.showLine && lineView == nil {
            assert(boxInputCellProperty.customLineViewBlock != nil, "customLineViewBlock can not be null！")
            let newLineView = boxInputCellProperty.customLineViewBlock()
            lineView = newLineView
            contentView.addSubview(newLineView)
            newLineView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }

        boxInputCellProperty.configCellShadowBlock?(layer)
        super.layoutSubviews()
    }
}
