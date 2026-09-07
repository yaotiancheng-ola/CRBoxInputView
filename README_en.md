<a id="Header_Start"></a> ![CRBoxInputViewHeadImg.png](/ReadmeResources/HeadImg.png "CRBoxInputViewHeadImg.png")
[![Version](https://img.shields.io/cocoapods/v/CRBoxInputView.svg?style=flat)](https://cocoapods.org/pods/CRBoxInputView)
[![License](https://img.shields.io/cocoapods/l/CRBoxInputView.svg?style=flat)](https://cocoapods.org/pods/CRBoxInputView)
[![Platform](https://img.shields.io/cocoapods/p/CRBoxInputView.svg?style=flat)](https://cocoapods.org/pods/CRBoxInputView)

### [中文文档](https://github.com/CRAnimation/CRBoxInputView#Header_Start) [/ English Document](https://github.com/CRAnimation/CRBoxInputView/blob/master/README_en.md#Header_Start)

## Features

- Implemented in Swift for iOS 12 and later
- Uses `SnapKit` for layout
- Supports one-time-code AutoFill
- Supports secure symbols, custom secure images, and custom views
- Supports changing `codeLength` dynamically

CRBoxInputView is suitable for verification codes, passwords, phone numbers, and similar input flows.

## Installation

### CocoaPods

```ruby
pod 'CRBoxInputView'
```

### Swift Package Manager

```swift
.package(url: "https://github.com/CRAnimation/CRBoxInputView.git", branch: "master")
```

## Example

Run `pod install` in the `Example` directory, then open the workspace and run the demo.

![Demo](/ReadmeResources/ScreenShoot3.png "Demo")

## Usage

### Base

![Normal](/ReadmeResources/1Normal.png "Normal")

```swift
import CRBoxInputView

let boxInputView = CRBoxInputView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
boxInputView.keyBoardType = .numberPad
boxInputView.inputType = .number
boxInputView.loadAndPrepareView(beginEdit: true)
view.addSubview(boxInputView)

boxInputView.textDidChangeblock = { text, isFinished in
    print("text: \(text ?? ""), finished: \(isFinished)")
}

print("textValue: \(boxInputView.textValue ?? "")")
boxInputView.clearAll(beginEdit: true)
```

Regex filtering:

```swift
boxInputView.inputType = .regex
boxInputView.customInputRegex = "[^0-9]"
```

### Placeholder

![Placeholder](/ReadmeResources/Add1_Placeholder0.png "Placeholder")

```swift
let cellProperty = CRBoxInputCellProperty()
cellProperty.cellPlaceholderTextColor = UIColor(
    red: 114.0 / 255.0,
    green: 116.0 / 255.0,
    blue: 124.0 / 255.0,
    alpha: 0.3
)
cellProperty.cellPlaceholderFont = .systemFont(ofSize: 20)

let boxInputView = CRBoxInputView(codeLength: 4)
boxInputView.ifNeedCursor = false
boxInputView.placeholderText = "1 2 3 4"
boxInputView.customCellProperty = cellProperty
boxInputView.loadAndPrepareView(beginEdit: true)
```

### Custom Box

![CustomBox](/ReadmeResources/2CustomBox.png "CustomBox")

```swift
let cellProperty = CRBoxInputCellProperty()
cellProperty.cellBgColorNormal = UIColor(red: 1, green: 236.0 / 255.0, blue: 236.0 / 255.0, alpha: 1)
cellProperty.cellBgColorSelected = .white
cellProperty.cellCursorColor = UIColor(red: 49.0 / 255.0, green: 51.0 / 255.0, blue: 64.0 / 255.0, alpha: 1)
cellProperty.cellCursorWidth = 2
cellProperty.cellCursorHeight = 30
cellProperty.cornerRadius = 4
cellProperty.borderWidth = 0
cellProperty.cellFont = .boldSystemFont(ofSize: 24)
cellProperty.configCellShadowBlock = { layer in
    layer.shadowOpacity = 1
    layer.shadowOffset = CGSize(width: 0, height: 2)
    layer.shadowRadius = 4
}

let boxInputView = CRBoxInputView(codeLength: 4)
boxInputView.boxFlowLayout.itemSize = CGSize(width: 50, height: 50)
boxInputView.customCellProperty = cellProperty
boxInputView.loadAndPrepareView(beginEdit: true)
```

### Line

![Line](/ReadmeResources/3.1Line.png "Line")

```swift
import SnapKit

let cellProperty = CRBoxInputCellProperty()
cellProperty.showLine = true
cellProperty.customLineViewBlock = {
    let lineView = CRLineView()
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

let boxInputView = CRBoxInputView(codeLength: 4)
boxInputView.customCellProperty = cellProperty
boxInputView.loadAndPrepareView(beginEdit: true)
```

### Secret Symbol

![SecretSymbol](/ReadmeResources/4SecretSymbol.png "SecretSymbol")

```swift
let cellProperty = CRBoxInputCellProperty()
cellProperty.securitySymbol = "*"

let boxInputView = CRBoxInputView(codeLength: 4)
boxInputView.ifNeedSecurity = true
boxInputView.customCellProperty = cellProperty
boxInputView.loadAndPrepareView(beginEdit: false)
boxInputView.ifClearAllInBeginEditing = true
boxInputView.reloadInputString("5678")
```

### Secret Image

![SecretImage](/ReadmeResources/5SecretImage.png "SecretImage")

```swift
let cellProperty = CRBoxInputCellProperty()
cellProperty.securityType = .customView
cellProperty.customSecurityViewBlock = {
    let imageView = CRSecrectImageView()
    imageView.image = UIImage(named: "smallLock")
    imageView.imageWidth = 23
    imageView.imageHeight = 27
    return imageView
}

let boxInputView = CRBoxInputView(codeLength: 4)
boxInputView.ifNeedSecurity = true
boxInputView.customCellProperty = cellProperty
boxInputView.loadAndPrepareView(beginEdit: true)
```

### Secret View

![SecretView](/ReadmeResources/6SecretView.png "SecretView")

```swift
let cellProperty = CRBoxInputCellProperty()
cellProperty.securityType = .customView
cellProperty.customSecurityViewBlock = {
    let container = UIView()
    let circle = UIView()
    circle.backgroundColor = .black
    circle.layer.cornerRadius = 4
    container.addSubview(circle)
    circle.snp.makeConstraints { make in
        make.width.height.equalTo(20)
        make.center.equalToSuperview()
    }
    return container
}
```

### Reset Code Length

![ResetCodeLength](/ReadmeResources/2ResetCodeLength.gif "ResetCodeLength")

```swift
boxInputView.resetCodeLength(boxInputView.codeLength + 1, beginEdit: true)
```

## Main APIs

- `CRBoxInputCellProperty`: border, background, cursor, font, line, security, and placeholder configuration.
- `CRBoxFlowLayout`: `ifNeedEqualGap`, `itemNum`, `minLineSpacing`, and `itemSize`.
- `CRBoxInputView`: input filtering, keyboard, security, code length, callbacks, preset values, clearing, and dynamic length changes.
- `CRLineView`: line colors and selection callbacks.
- `CRBoxInputCell`: subclasses may override `createCustomSecurityView()`; new code should use `customSecurityViewBlock`.

## License

CRBoxInputView is available under the MIT license. See the LICENSE file for more info.
