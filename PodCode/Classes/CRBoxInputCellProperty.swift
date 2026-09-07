import SnapKit
import UIKit

public enum CRBoxSecurityType: Int {
    case symbol
    case customView
}

public typealias CustomSecurityViewBlock = () -> UIView
public typealias CustomLineViewBlock = () -> CRLineView
public typealias ConfigCellShadowBlock = (CALayer) -> Void

open class CRBoxInputCellProperty {
    public var borderWidth: CGFloat = 0.5
    public var cellBorderColorNormal = UIColor(red: 228.0 / 255.0, green: 228.0 / 255.0, blue: 228.0 / 255.0, alpha: 1)
    public var cellBorderColorSelected = UIColor(red: 1, green: 70.0 / 255.0, blue: 62.0 / 255.0, alpha: 1)
    public var cellBorderColorFilled: UIColor?
    public var cellBgColorNormal = UIColor.white
    public var cellBgColorSelected = UIColor.white
    public var cellBgColorFilled: UIColor?
    public var cellCursorColor = UIColor(red: 1, green: 70.0 / 255.0, blue: 62.0 / 255.0, alpha: 1)
    public var cellCursorWidth: CGFloat = 2
    public var cellCursorHeight: CGFloat = 32
    public var cornerRadius: CGFloat = 4

    public var showLine = false
    public var cellFont = UIFont.systemFont(ofSize: 20)
    public var cellTextColor = UIColor.black

    public var ifShowSecurity = false
    public var securitySymbol = "✱"
    public private(set) var originValue = ""
    public var securityType: CRBoxSecurityType = .symbol

    public var cellPlaceholderText: String?
    public var cellPlaceholderTextColor = UIColor(red: 114.0 / 255.0, green: 116.0 / 255.0, blue: 124.0 / 255.0, alpha: 0.3)
    public var cellPlaceholderFont = UIFont.systemFont(ofSize: 20)

    public var customSecurityViewBlock: CustomSecurityViewBlock!
    public var customLineViewBlock: CustomLineViewBlock!
    public var configCellShadowBlock: ConfigCellShadowBlock?
    public var index = 0

    public required init() {
        customSecurityViewBlock = { [weak self] in
            self?.defaultCustomSecurityView() ?? UIView()
        }
        customLineViewBlock = { CRLineView() }
    }

    open func copy() -> CRBoxInputCellProperty {
        let copy = type(of: self).init()
        copy.borderWidth = borderWidth
        copy.cellBorderColorNormal = cellBorderColorNormal
        copy.cellBorderColorSelected = cellBorderColorSelected
        copy.cellBorderColorFilled = cellBorderColorFilled
        copy.cellBgColorNormal = cellBgColorNormal
        copy.cellBgColorSelected = cellBgColorSelected
        copy.cellBgColorFilled = cellBgColorFilled
        copy.cellCursorColor = cellCursorColor
        copy.cellCursorWidth = cellCursorWidth
        copy.cellCursorHeight = cellCursorHeight
        copy.cornerRadius = cornerRadius
        copy.showLine = showLine
        copy.cellFont = cellFont
        copy.cellTextColor = cellTextColor
        copy.ifShowSecurity = ifShowSecurity
        copy.securitySymbol = securitySymbol
        copy.originValue = originValue
        copy.securityType = securityType
        copy.cellPlaceholderText = cellPlaceholderText
        copy.cellPlaceholderTextColor = cellPlaceholderTextColor
        copy.cellPlaceholderFont = cellPlaceholderFont
        copy.customSecurityViewBlock = customSecurityViewBlock
        copy.customLineViewBlock = customLineViewBlock
        copy.configCellShadowBlock = configCellShadowBlock
        copy.index = index
        return copy
    }

    public func setMyOriginValue(_ originValue: String) {
        self.originValue = originValue
    }

    private func defaultCustomSecurityView() -> UIView {
        let customSecurityView = UIView()
        customSecurityView.backgroundColor = .clear

        let circleView = UIView()
        circleView.backgroundColor = .black
        circleView.layer.cornerRadius = 4
        customSecurityView.addSubview(circleView)
        circleView.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.center.equalToSuperview()
        }
        return customSecurityView
    }
}
