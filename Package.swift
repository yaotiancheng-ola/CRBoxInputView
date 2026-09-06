// swift-tools-version:5.7
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
        .package(url: "https://github.com/wei18/Masonry.git", branch: "master")
    ],
    targets: [
        .target(
            name: "CRBoxInputView",
            dependencies: [
                "Masonry"
            ],
            path: "PodCode/Classes",
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath(".")
            ],
            linkerSettings: [
                .linkedFramework("UIKit"),
                .linkedFramework("Foundation")
            ]
        )
    ]
)
