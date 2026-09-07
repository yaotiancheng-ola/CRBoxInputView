import UIKit

@main
@objc(CRAppDelegate)
final class CRAppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        Thread.sleep(forTimeInterval: 2)
        return true
    }
}
