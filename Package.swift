// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

struct Additions {
    struct ForPackage {
        static func dependecies() -> [Package.Dependency] {
            #if os(Linux)
            return [.package(name: "CSQLite", url: "https://SiavA@bitbucket.org/SiavA/csqlite.git", .branch("master"))]
            #else
            return []
            #endif
        }
    }
    struct ForTarget {
        static func dependecies() -> [Target.Dependency] {
            #if os(Linux)
            return ["CSQLite"]
            #else
            return []
            #endif
        }
    }
}

let package = Package(
    name: "SSSugar",
    platforms: [
        .macOS(.v11),
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "SSSugar",
            targets: ["SSSugarUIKit", "SSSugarCore"]),
        .library(
            name: "SSSugarCore",
            targets: ["SSSugarCore"]),
        .library(
            name: "SSSugarDynamic",
            type: .dynamic,
            targets: ["SSSugarUIKit", "SSSugarCore"]),
        .executable(
            name: "SSSugarPG",
            targets: ["SSSugarPG"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.4.0"),
    ]
    + Additions.ForPackage.dependecies(),
    targets: [
        .target(
            name: "SSSugarCore", dependencies: [] + Additions.ForTarget.dependecies() ),
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
