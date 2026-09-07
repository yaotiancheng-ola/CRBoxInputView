// swift-tools-version:5.8
import PackageDescription

let package = Package(
    name: "CRBoxInputView",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "CRBoxInputView",
            targets: ["CRBoxInputView"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/SnapKit/SnapKit.git", exact: "5.7.1")
    ],
    targets: [
        .target(
            name: "CRBoxInputView",
            dependencies: [
                .product(name: "SnapKit", package: "SnapKit")
            ],
            path: "PodCode/Classes"
        )
    ]
)
