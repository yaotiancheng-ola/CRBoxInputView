import CRBoxInputView
import SnapKit
import UIKit

final class CRDetailViewController: UIViewController {
    var boxInputModel: CRBoxInputModel! {
        didSet { configure(for: boxInputModel) }
    }

    private let backButton = UIButton()
    private let bigLockImageView = UIImageView()
    private let mainLabel = UILabel()
    private let subLabel = UILabel()
    private let separatorLineView = UIView()
    private let descriptionLabel = UILabel()
    private let verifyButton = UIButton()
    private let menuView = UIView()
    private let ifNeedSecurityButton = UIButton()
    private let addButton = UIButton()
    private let removeButton = UIButton()
    private let valueLabel = UILabel()
    private var boxInputView: CRBoxInputView!

    private var startOffset: CGFloat { xx6(35) }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        view.backgroundColor = .white
        createUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        view.backgroundColor = .white
        createUI()
    }

    private func createUI() {
        backButton.setImage(UIImage(named: "backArrow"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(startOffset)
            make.top.equalToSuperview().offset(yy6(16) + statusHeight)
            make.width.equalTo(xx6(24))
            make.height.equalTo(xx6(22))
        }

        bigLockImageView.image = UIImage(named: "BigLock")
        view.addSubview(bigLockImageView)
        bigLockImageView.snp.makeConstraints { make in
            make.top.right.equalToSuperview()
            make.width.equalTo(xx6(154))
            make.height.equalTo(xx6(230))
        }

        mainLabel.textColor = colorMaster
        mainLabel.font = .systemFont(ofSize: 24)
        view.addSubview(mainLabel)
        mainLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(startOffset)
            make.top.equalTo(backButton.snp.bottom).offset(13)
        }

        separatorLineView.backgroundColor = colorMaster
        view.addSubview(separatorLineView)
        separatorLineView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(startOffset)
            make.top.equalTo(mainLabel.snp.bottom).offset(5)
            make.width.equalTo(xx6(166))
            make.height.equalTo(2)
        }

        subLabel.text = "CRBoxInputView"
        subLabel.textColor = colorMaster
        subLabel.font = .boldSystemFont(ofSize: 14)
        view.addSubview(subLabel)
        subLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(startOffset)
            make.top.equalTo(separatorLineView.snp.bottom).offset(2)
        }

        descriptionLabel.textColor = colorMaster
        descriptionLabel.font = .boldSystemFont(ofSize: 16)
        descriptionLabel.text = "The verification code you have input is"
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.width.equalTo(xx6(303))
            make.centerX.equalToSuperview()
            make.top.equalTo(subLabel.snp.bottom).offset(yy6(24))
        }

        valueLabel.textColor = colorMaster
        valueLabel.font = .boldSystemFont(ofSize: 24)
        valueLabel.text = "Empty"
        view.addSubview(valueLabel)
        valueLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(descriptionLabel.snp.bottom).offset(3)
        }

        let buttonHeight = yy6(54)
        verifyButton.layer.cornerRadius = buttonHeight / 2
        verifyButton.backgroundColor = colorMaster
        verifyButton.setTitle("Clear", for: .normal)
        verifyButton.setTitleColor(.white, for: .normal)
        verifyButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        verifyButton.titleLabel?.font = fontSize6(21)
        view.addSubview(verifyButton)
        verifyButton.snp.makeConstraints { make in
            make.width.equalTo(xx6(297))
            make.height.equalTo(buttonHeight)
            make.centerX.equalToSuperview()
        }

        createSecurityControlView()
    }

    private func createSecurityControlView() {
        let buttonWidth = xx6(40)
        view.addSubview(menuView)
        menuView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(startOffset)
            make.right.equalToSuperview().offset(-startOffset)
            make.top.equalTo(verifyButton.snp.bottom).offset(21)
            make.height.equalTo(buttonWidth)
        }

        ifNeedSecurityButton.addTarget(self, action: #selector(securityButtonTapped), for: .touchUpInside)
        ifNeedSecurityButton.adjustsImageWhenHighlighted = false
        ifNeedSecurityButton.setImage(UIImage(named: "eyeOpen"), for: .normal)
        ifNeedSecurityButton.setImage(UIImage(named: "eyeClose"), for: .selected)
        menuView.addSubview(ifNeedSecurityButton)
        ifNeedSecurityButton.snp.makeConstraints { make in
            make.left.centerY.equalToSuperview()
            make.width.height.equalTo(buttonWidth)
        }

        removeButton.addTarget(self, action: #selector(removeCodeItem), for: .touchUpInside)
        removeButton.setImage(UIImage(named: "cellRemove"), for: .normal)
        menuView.addSubview(removeButton)
        removeButton.snp.makeConstraints { make in
            make.right.centerY.equalToSuperview()
            make.width.height.equalTo(buttonWidth)
        }

        addButton.addTarget(self, action: #selector(addCodeItem), for: .touchUpInside)
        addButton.setImage(UIImage(named: "cellAdd"), for: .normal)
        menuView.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.right.equalTo(removeButton.snp.left).offset(-12)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(buttonWidth)
        }
    }

    private func configure(for model: CRBoxInputModel) {
        mainLabel.text = model.name
        switch model.type {
        case .normal:
            boxInputView = generateNormalBoxInputView()
        case .placeholder:
            boxInputView = generatePlaceholderBoxInputView()
        case .customBox:
            boxInputView = generateCustomBoxInputView()
        case .line:
            boxInputView = generateLineBoxInputView()
        case .secretSymbol:
            boxInputView = generateSecretSymbolBoxInputView()
        case .secretImage:
            boxInputView = generateSecretImageBoxInputView()
        case .secretView:
            boxInputView = generateSecretViewBoxInputView()
        }

        if boxInputView.textDidChangeblock == nil {
            boxInputView.textDidChangeblock = { [weak self] text, _ in
                self?.valueLabel.text = text?.isEmpty == false ? text : "Empty"
            }
        }

        view.addSubview(boxInputView)
        boxInputView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(startOffset)
            make.right.equalToSuperview().offset(-startOffset)
            make.height.equalTo(yy6(52))
            make.top.equalTo(bigLockImageView.snp.bottom).offset(yy6(18))
        }
        verifyButton.snp.makeConstraints { make in
            make.top.equalTo(boxInputView.snp.bottom).offset(yy6(46))
        }
    }

    private func generateNormalBoxInputView() -> CRBoxInputView {
        let inputView = CRBoxInputView(codeLength: 4)
        inputView.mainCollectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        inputView.loadAndPrepareView(beginEdit: true)
        inputView.inputType = .number
        inputView.inputType = .regex
        inputView.customInputRegex = "[^0-9]"
        inputView.textContentType = .oneTimeCode
        return inputView
    }

    private func generatePlaceholderBoxInputView() -> CRBoxInputView {
        let cellProperty = CRBoxInputCellProperty()
        cellProperty.cellPlaceholderTextColor = UIColor(
            red: 114.0 / 255.0,
            green: 116.0 / 255.0,
            blue: 124.0 / 255.0,
            alpha: 0.3
        )
        cellProperty.cellPlaceholderFont = .systemFont(ofSize: 20)

        let inputView = CRBoxInputView(codeLength: 4)
        inputView.mainCollectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        inputView.ifNeedCursor = false
        inputView.placeholderText = "露可娜娜"
        inputView.customCellProperty = cellProperty
        inputView.loadAndPrepareView(beginEdit: true)
        return inputView
    }

    private func makeBaseCellProperty() -> CRBoxInputCellProperty {
        let cellProperty = CRBoxInputCellProperty()
        cellProperty.cellCursorColor = colorFFECEC
        cellProperty.cellCursorWidth = 2
        cellProperty.cellCursorHeight = yy6(27)
        cellProperty.cornerRadius = 0
        cellProperty.borderWidth = 0
        cellProperty.cellFont = .boldSystemFont(ofSize: 24)
        cellProperty.cellTextColor = colorMaster
        return cellProperty
    }

    private func makeInputView(cellProperty: CRBoxInputCellProperty, beginEdit: Bool) -> CRBoxInputView {
        let inputView = CRBoxInputView(codeLength: 4)
        inputView.mainCollectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        inputView.boxFlowLayout.itemSize = CGSize(width: xx6(52), height: xx6(52))
        inputView.customCellProperty = cellProperty
        inputView.loadAndPrepareView(beginEdit: beginEdit)
        return inputView
    }

    private func generateCustomBoxInputView() -> CRBoxInputView {
        let cellProperty = CRBoxInputCellProperty()
        cellProperty.cellBgColorNormal = colorFFECEC
        cellProperty.cellBgColorSelected = .white
        cellProperty.cellCursorColor = colorMaster
        cellProperty.cellCursorWidth = 2
        cellProperty.cellCursorHeight = yy6(27)
        cellProperty.cornerRadius = 4
        cellProperty.borderWidth = 0
        cellProperty.cellFont = .boldSystemFont(ofSize: 24)
        cellProperty.cellTextColor = colorMaster
        cellProperty.configCellShadowBlock = { layer in
            layer.shadowColor = colorMaster.withAlphaComponent(0.2).cgColor
            layer.shadowOpacity = 1
            layer.shadowOffset = CGSize(width: 0, height: 2)
            layer.shadowRadius = 4
        }
        return makeInputView(cellProperty: cellProperty, beginEdit: true)
    }

    private func generateLineBoxInputView() -> CRBoxInputView {
        let cellProperty = makeBaseCellProperty()
        cellProperty.showLine = true
        cellProperty.customLineViewBlock = {
            let lineView = CRLineView()
            lineView.underlineColorNormal = colorMaster.withAlphaComponent(0.3)
            lineView.underlineColorSelected = colorMaster.withAlphaComponent(0.7)
            lineView.underlineColorFilled = colorMaster
            lineView.lineView.snp.remakeConstraints { make in
                make.height.equalTo(4)
                make.left.right.bottom.equalToSuperview()
            }
            lineView.selectChangeBlock = { lineView, selected in
                lineView.lineView.snp.updateConstraints { make in
                    make.height.equalTo(selected ? 6 : 4)
                }
            }
            return lineView
        }
        return makeInputView(cellProperty: cellProperty, beginEdit: true)
    }

    private func generateSecretSymbolBoxInputView() -> CRBoxInputView {
        let cellProperty = makeBaseCellProperty()
        cellProperty.showLine = true
        cellProperty.securitySymbol = "*"

        let inputView = CRBoxInputView(codeLength: 4)
        inputView.mainCollectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        inputView.ifNeedSecurity = true
        inputView.boxFlowLayout.itemSize = CGSize(width: xx6(52), height: xx6(52))
        inputView.customCellProperty = cellProperty
        inputView.loadAndPrepareView(beginEdit: false)
        inputView.textDidChangeblock = { [weak self] text, _ in
            self?.valueLabel.text = text?.isEmpty == false ? text : "Empty"
        }
        inputView.ifClearAllInBeginEditing = true
        inputView.reloadInputString("5678")
        return inputView
    }

    private func generateSecretImageBoxInputView() -> CRBoxInputView {
        let cellProperty = makeBaseCellProperty()
        cellProperty.showLine = true
        cellProperty.securityType = .customView
        cellProperty.customSecurityViewBlock = {
            let imageView = CRSecrectImageView()
            imageView.image = UIImage(named: "smallLock")
            imageView.imageWidth = 23
            imageView.imageHeight = 27
            return imageView
        }

        let inputView = CRBoxInputView(codeLength: 4)
        inputView.mainCollectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        inputView.ifNeedSecurity = true
        inputView.boxFlowLayout.itemSize = CGSize(width: xx6(52), height: xx6(52))
        inputView.customCellProperty = cellProperty
        inputView.loadAndPrepareView(beginEdit: true)
        return inputView
    }

    private func generateSecretViewBoxInputView() -> CRBoxInputView {
        let cellProperty = makeBaseCellProperty()
        cellProperty.showLine = true
        cellProperty.securityType = .customView
        cellProperty.customSecurityViewBlock = {
            let customSecurityView = UIView()
            customSecurityView.backgroundColor = .clear
            let circleView = UIView()
            circleView.backgroundColor = colorMaster
            circleView.layer.cornerRadius = 4
            customSecurityView.addSubview(circleView)
            circleView.snp.makeConstraints { make in
                make.width.height.equalTo(20)
                make.center.equalToSuperview()
            }
            return customSecurityView
        }

        let inputView = CRBoxInputView(codeLength: 4)
        inputView.mainCollectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        inputView.ifNeedSecurity = true
        inputView.boxFlowLayout.itemSize = CGSize(width: xx6(52), height: xx6(52))
        inputView.customCellProperty = cellProperty
        inputView.loadAndPrepareView(beginEdit: true)
        return inputView
    }

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func securityButtonTapped() {
        boxInputView.ifNeedSecurity.toggle()
        ifNeedSecurityButton.isSelected = boxInputView.ifNeedSecurity
    }

    @objc private func addCodeItem() {
        boxInputView.resetCodeLength(boxInputView.codeLength + 1, beginEdit: true)
    }

    @objc private func removeCodeItem() {
        if boxInputView.codeLength > 0 {
            boxInputView.resetCodeLength(boxInputView.codeLength - 1, beginEdit: true)
        }
    }

    @objc private func clearButtonTapped() {
        boxInputView.clearAll()
    }
}
