// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "SGen",
    products: [
        .executable(name: "sgen", targets: ["SGen"]),
    ],
    dependencies: [
      .package(url: "https://github.com/kylef/Commander.git", from: "0.8.0"),
      .package(url: "https://github.com/kylef/PathKit.git", from: "0.9.2"),
      .package(url: "https://github.com/behrang/YamlSwift.git", from: "3.4.4"),
      .package(url: "https://github.com/tuist/xcodeproj", from: "6.7.0"),
    ],
    targets: [
      .target(name: "SGen", dependencies: [
        "Commander",
        "PathKit",
        "Yaml",
        "xcodeproj"
      ]),
      .testTarget(name: "SGenTests", dependencies: [
        "SGen"
      ]),
    ]
)
