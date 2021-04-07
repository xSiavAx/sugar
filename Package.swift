// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SSSugar",
    platforms: [
        .macOS(.v11),
        .iOS(.v11)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SSSugar",
            targets: ["SSSugarUIKit", "SSSugarCore"]),
        .library(
            name: "SSSugarCore",
            targets: ["SSSugarCore"]),
        .executable(
            name: "SSSugarPG",
            targets: ["SSSugarPG"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.4.0"),
        .package(url: "https://github.com/PerfectlySoft/Perfect-sqlite3-support.git", from: "3.0.0")
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SSSugarCore", dependencies: []),
        .target(
            name: "SSSugarUIKit", dependencies: ["SSSugarCore"]),
        .target(
            name: "SSSugarPG",
            dependencies: ["SSSugarCore",
                           .product(name: "ArgumentParser", package: "swift-argument-parser")]),
        .testTarget(
            name: "SSSugarCoreTests",
            dependencies: ["SSSugarCore"]),
        .testTarget(
            name: "SSSugarUIKitTests",
            dependencies: ["SSSugarUIKit", "SSSugarCore"]),
    ]
)
