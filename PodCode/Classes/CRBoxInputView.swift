import SnapKit
import UIKit

@objc public enum CRTextEditStatus: Int {
    case idle
    case beginEdit
    case endEdit
}

@objc public enum CRInputType: Int {
    case number
    case normal
    case regex
}

private enum CRBoxTextChangeType {
    case noChange
    case insert
    case delete
}

public typealias TextDidChangeblock = (String?, Bool) -> Void
public typealias TextEditStatusChangeblock = (CRTextEditStatus) -> Void
public typealias TextCustomProcessblock = (String?) -> String

@objcMembers
open class CRBoxInputView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate {
    public var ifNeedCursor = true
    public private(set) var codeLength = 4 {
        didSet { boxFlowLayout.itemNum = codeLength }
    }
    public var ifNeedSecurity = false {
        didSet {
            if ifNeedSecurity {
                allSecurityOpen()
            } else {
                allSecurityClose()
            }
            DispatchQueue.main.async { [weak self] in self?.reloadAllCell() }
        }
    }
    public var securityDelay: CGFloat = 0.3
    public var keyBoardType: UIKeyboardType = .numberPad {
        didSet { textView.keyboardType = keyBoardType }
    }
    public var inputType: CRInputType = .number
    public var customInputRegex: String? = ""
    public var textContentType: UITextContentType? {
        didSet { textView.textContentType = textContentType }
    }
    public var placeholderText: String?
    public var ifClearAllInBeginEditing = false

    public var textDidChangeblock: TextDidChangeblock?
    public var textEditStatusChangeblock: TextEditStatusChangeblock?
    public var textCustomProcessblock: TextCustomProcessblock?
    public var boxFlowLayout = CRBoxFlowLayout() {
        didSet {
            boxFlowLayout.itemNum = codeLength
            collectionViewStorage?.setCollectionViewLayout(boxFlowLayout, animated: false)
        }
    }
    public var customCellProperty = CRBoxInputCellProperty()
    public var textValue: String? { textView.text }

    private var accessoryViewStorage: UIView?
    open override var inputAccessoryView: UIView? {
        get { accessoryViewStorage }
        set {
            accessoryViewStorage = newValue
            textView.inputAccessoryView = newValue
        }
    }

    private var collectionViewStorage: UICollectionView?
    public var mainCollectionView: UICollectionView {
        if let collectionViewStorage {
            return collectionViewStorage
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: boxFlowLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.layer.masksToBounds = true
        collectionView.clipsToBounds = true
        collectionView.register(CRBoxInputCell.self, forCellWithReuseIdentifier: CRBoxInputCellID)
        collectionViewStorage = collectionView
        return collectionView
    }

    private lazy var tapGR = UITapGestureRecognizer(target: self, action: #selector(beginEdit))
    private lazy var textView: CRBoxTextView = {
        let textView = CRBoxTextView()
        textView.delegate = self
        textView.keyboardType = keyBoardType
        textView.textContentType = textContentType
        textView.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        return textView
    }()

    private var oldLength = 0
    private var ifNeedBeginEdit = false
    private var valueArr: [String] = []
    private var cellPropertyArr: [CRBoxInputCellProperty] = []

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    @objc(initWithCodeLength:)
    public convenience init(codeLength: Int) {
        self.init(frame: .zero)
        self.codeLength = codeLength
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func initialize() {
        initDefaultValue()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationWillResignActive(_:)),
            name: UIApplication.willResignActiveNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationDidBecomeActive(_:)),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }

    @objc private func applicationWillResignActive(_ notification: Notification) {}

    @objc private func applicationDidBecomeActive(_ notification: Notification) {
        reloadAllCell()
    }

    /// Public customization point retained from the Objective-C implementation.
    open func initDefaultValue() {
        oldLength = 0
        ifNeedSecurity = false
        securityDelay = 0.3
        codeLength = 4
        ifNeedCursor = true
        keyBoardType = .numberPad
        inputType = .number
        customInputRegex = ""
        backgroundColor = .clear
        valueArr = []
        ifNeedBeginEdit = false
    }

    open func loadAndPrepareView() {
        loadAndPrepareView(beginEdit: true)
    }

    @objc(loadAndPrepareViewWithBeginEdit:)
    open func loadAndPrepareView(beginEdit: Bool) {
        guard codeLength > 0 else {
            assertionFailure("请输入大于0的验证码位数")
            return
        }

        generateCellPropertyArr()
        if mainCollectionView.superview !== self {
            addSubview(mainCollectionView)
            mainCollectionView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        if textView.superview !== self {
            addSubview(textView)
            textView.snp.makeConstraints { make in
                make.width.height.equalTo(0)
                make.left.top.equalToSuperview()
            }
        }
        if tapGR.view !== self {
            addGestureRecognizer(tapGR)
        }
        if textView.text != customCellProperty.originValue {
            textView.text = customCellProperty.originValue
            textDidChange(textView)
        }
        if beginEdit {
            self.beginEdit()
        }
    }

    private func generateCellPropertyArr() {
        cellPropertyArr.removeAll()
        for _ in 0..<codeLength {
            cellPropertyArr.append(customCellProperty.copy() as! CRBoxInputCellProperty)
        }
    }

    @objc(resetCodeLength:beginEdit:)
    open func resetCodeLength(_ codeLength: Int, beginEdit: Bool) {
        guard codeLength > 0 else {
            assertionFailure("请输入大于0的验证码位数")
            return
        }
        self.codeLength = codeLength
        generateCellPropertyArr()
        clearAll(beginEdit: beginEdit)
    }

    open func reloadInputString(_ value: String?) {
        if textView.text != value {
            textView.text = value
            baseTextDidChange(textView, manualInvoke: true)
        }
    }

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        ifNeedBeginEdit = true
        if ifClearAllInBeginEditing && (textValue as NSString?)?.length == codeLength {
            clearAll()
        }
        textEditStatusChangeblock?(.beginEdit)
        reloadAllCell()
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        ifNeedBeginEdit = false
        textEditStatusChangeblock?(.endEdit)
        reloadAllCell()
    }

    @objc private func beginEdit() {
        if !textView.isFirstResponder {
            textView.becomeFirstResponder()
        }
    }

    private func endEdit() {
        if textView.isFirstResponder {
            textView.resignFirstResponder()
        }
    }

    open func clearAll() {
        clearAll(beginEdit: true)
    }

    @objc(clearAllWithBeginEdit:)
    open func clearAll(beginEdit: Bool) {
        oldLength = 0
        valueArr.removeAll()
        textView.text = ""
        allSecurityClose()
        reloadAllCell()
        triggerBlock()
        if beginEdit {
            self.beginEdit()
        }
    }

    @objc private func textDidChange(_ textField: UITextField) {
        baseTextDidChange(textField, manualInvoke: false)
    }

    private func filterInputContent(_ input: String) -> String {
        let mutable = NSMutableString(string: input)
        let pattern: String?
        switch inputType {
        case .number:
            pattern = "[^0-9]"
        case .normal:
            pattern = nil
        case .regex:
            pattern = customInputRegex?.isEmpty == false ? customInputRegex : nil
        }
        if let pattern, let regex = try? NSRegularExpression(pattern: pattern) {
            regex.replaceMatches(in: mutable, range: NSRange(location: 0, length: mutable.length), withTemplate: "")
        }
        return mutable as String
    }

    private func baseTextDidChange(_ textField: UITextField, manualInvoke: Bool) {
        var value = (textField.text ?? "").replacingOccurrences(of: " ", with: "")
        value = filterInputContent(value)
        if let textCustomProcessblock {
            value = textCustomProcessblock(value)
        }

        let nsValue = value as NSString
        if nsValue.length >= codeLength {
            value = nsValue.substring(to: codeLength)
            endEdit()
        }
        textField.text = value

        let valueLength = (value as NSString).length
        let changeType: CRBoxTextChangeType
        if valueLength > oldLength {
            changeType = .insert
        } else if valueLength < oldLength {
            changeType = .delete
        } else {
            changeType = .noChange
        }

        switch changeType {
        case .delete:
            setSecurityShow(false, index: valueArr.count - 1)
            valueArr.removeLast()
        case .insert:
            if !value.isEmpty {
                if !valueArr.isEmpty {
                    replaceValueArrToAsterisk(index: valueArr.count - 1, needEqualToCount: false)
                }
                valueArr.removeAll()
                value.enumerateSubstrings(in: value.startIndex..<value.endIndex, options: .byComposedCharacterSequences) {
                    [weak self] substring, _, _, _ in
                    if let substring { self?.valueArr.append(substring) }
                }
                if ifNeedSecurity {
                    if manualInvoke {
                        delaySecurityProcessAll()
                    } else {
                        delaySecurityProcessLastOne()
                    }
                }
            }
        case .noChange:
            break
        }

        reloadAllCell()
        oldLength = valueLength
        if changeType != .noChange {
            triggerBlock()
        }
    }

    private func setSecurityShow(_ isShow: Bool, index: Int) {
        guard index >= 0 else {
            assertionFailure("index必须大于等于0")
            return
        }
        cellPropertyArr[index].ifShowSecurity = isShow
    }

    private func allSecurityClose() {
        cellPropertyArr.forEach { $0.ifShowSecurity = false }
    }

    private func allSecurityOpen() {
        cellPropertyArr.forEach { $0.ifShowSecurity = true }
    }

    private func triggerBlock() {
        textDidChangeblock?(textView.text, valueArr.count == codeLength)
    }

    private func replaceValueArrToAsterisk(index: Int, needEqualToCount: Bool) {
        guard ifNeedSecurity else { return }
        guard !needEqualToCount || index == valueArr.count - 1 else { return }
        setSecurityShow(true, index: index)
    }

    private func delaySecurityProcessLastOne() {
        DispatchQueue.main.asyncAfter(deadline: .now() + securityDelay) { [weak self] in
            guard let self, !self.valueArr.isEmpty else { return }
            self.replaceValueArrToAsterisk(index: self.valueArr.count - 1, needEqualToCount: true)
            self.reloadAllCell()
        }
    }

    private func delaySecurityProcessAll() {
        for index in valueArr.indices {
            replaceValueArrToAsterisk(index: index, needEqualToCount: false)
        }
        reloadAllCell()
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        codeLength
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let result = customCollectionView(collectionView, cellForItemAt: indexPath)
        guard let cell = result as? CRBoxInputCell else { return result }

        cell.ifNeedCursor = ifNeedCursor
        let cellProperty = cellPropertyArr[indexPath.row]
        cellProperty.index = indexPath.row

        let placeholder = placeholderText as NSString?
        if let placeholder, placeholder.length > indexPath.row {
            cellProperty.cellPlaceholderText = placeholder.substring(with: NSRange(location: indexPath.row, length: 1))
        }

        let focusIndex = valueArr.count
        if !valueArr.isEmpty && indexPath.row <= focusIndex - 1 {
            cellProperty.setMyOriginValue(valueArr[indexPath.row])
        } else {
            cellProperty.setMyOriginValue("")
        }
        cell.boxInputCellProperty = cellProperty
        cell.isSelected = ifNeedBeginEdit && indexPath.row == focusIndex
        return cell
    }

    private func reloadAllCell() {
        mainCollectionView.reloadData()
        let focusIndex = valueArr.count
        guard codeLength > 0 else { return }
        if focusIndex == codeLength {
            mainCollectionView.scrollToItem(
                at: IndexPath(row: focusIndex - 1, section: 0),
                at: .right,
                animated: true
            )
        } else {
            mainCollectionView.scrollToItem(
                at: IndexPath(row: focusIndex, section: 0),
                at: .centeredHorizontally,
                animated: true
            )
        }
    }

    open func quickSetSecuritySymbol(_ securitySymbol: String?) {
        customCellProperty.securitySymbol = (securitySymbol as NSString?)?.length == 1 ? securitySymbol! : "✱"
    }

    /// Public subclassing hook retained from the Objective-C implementation.
    @objc(customCollectionView:cellForItemAtIndexPath:)
    open func customCollectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(withReuseIdentifier: CRBoxInputCellID, for: indexPath)
    }
}
