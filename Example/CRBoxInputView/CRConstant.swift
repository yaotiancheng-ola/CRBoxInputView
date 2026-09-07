import UIKit

let colorMaster = UIColor(red: 49.0 / 255.0, green: 51.0 / 255.0, blue: 64.0 / 255.0, alpha: 1)
let colorFFECEC = UIColor(red: 1, green: 236.0 / 255.0, blue: 236.0 / 255.0, alpha: 1)

func xx6(_ value: CGFloat) -> CGFloat {
    value * UIScreen.main.bounds.width / 375.0
}

func yy6(_ value: CGFloat) -> CGFloat {
    let layoutHeight = max(UIScreen.main.bounds.height, 568.0)
    return value * layoutHeight / 667.0
}

func fontSize6(_ value: CGFloat) -> UIFont {
    .systemFont(ofSize: floor(xx6(value)))
}

var statusHeight: CGFloat {
    UIApplication.shared.statusBarFrame.height
}
