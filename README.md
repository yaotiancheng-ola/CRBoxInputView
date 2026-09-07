<a id="Header_Start"></a> ![CRBoxInputViewHeadImg.png](/ReadmeResources/HeadImg.png "CRBoxInputViewHeadImg.png")
[![Version](https://img.shields.io/cocoapods/v/CRBoxInputView.svg?style=flat)](https://cocoapods.org/pods/CRBoxInputView)
[![License](https://img.shields.io/cocoapods/l/CRBoxInputView.svg?style=flat)](https://cocoapods.org/pods/CRBoxInputView)
[![Platform](https://img.shields.io/cocoapods/p/CRBoxInputView.svg?style=flat)](https://cocoapods.org/pods/CRBoxInputView)

### [中文文档](https://github.com/yaotiancheng-ola/CRBoxInputView#Header_Start) [/ English Document](https://github.com/yaotiancheng-ola/CRBoxInputView/blob/master/README_en.md#Header_Start)

## 组件特点

- Swift 实现，支持 iOS 12 及以上版本
- 使用 `SnapKit` 布局
- 支持短信验证码自动填充
- 支持密文符号、自定义密文图片和自定义 View
- 支持动态修改 `codeLength`

该组件适用于短信验证码、密码和手机号码输入等场景。

## 安装

### CocoaPods

```ruby
pod 'CRBoxInputView', '2.0.0'
```

### Swift Package Manager

```swift
.package(url: "https://github.com/yaotiancheng-ola/CRBoxInputView.git", from: "2.0.0")
```

## 示例

下载源码后，在 `Example` 目录执行 `pod install`，然后打开 workspace 运行 Demo。

![Demo](/ReadmeResources/ScreenShoot3.png "Demo")

## 使用说明

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

正则过滤：

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
boxInputView.placeholderText = "露可娜娜"
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

## 主要 API

- `CRBoxInputCellProperty`：边框、背景、光标、字体、下划线、密文和占位符配置。
- `CRBoxFlowLayout`：`ifNeedEqualGap`、`itemNum`、`minLineSpacing` 和 `itemSize`。
- `CRBoxInputView`：输入类型、键盘、密文、位数、回调、预填、清空及动态位数调整。
- `CRLineView`：下划线颜色与选中状态回调。
- `CRBoxInputCell`：支持通过继承覆盖 `createCustomSecurityView()`；新代码建议使用 `customSecurityViewBlock`。

## License

CRBoxInputView is available under the MIT license. See the LICENSE file for more info.
