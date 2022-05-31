// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

struct Additions {
    struct ForPackage {
        static func dependecies() -> [Package.Dependency] {
            #if os(Linux)
            return [.package(name: "CSQLiteSS", url: "git@bitbucket.org:SiavA/csqlitess.git", from: "1.0.0")]
            #else
            return []
            #endif
        }
    }
    struct ForTarget {
        static func dependecies() -> [Target.Dependency] {
            #if os(Linux)
            return ["CSQLiteSS"]
            #else
            return []
            #endif
        }
    }
}

let allMacTargets = [
    "SSSugarCore",
    "SSSugarExecutors",
    "SSSugarDataSynchronisation",
    "SSSugarTesting"
]

let allTargets = allMacTargets + ["SSSugarUIKit"]

let package = Package(
    name: "SSSugar",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "SSSugarCore",
            targets: ["SSSugarCore"]
        ),
        .library(
            name: "SSSugarExecutors",
            targets: ["SSSugarExecutors"]
        ),
        .library(
            name: "SSSugarDataSynchronisation",
            targets: ["SSSugarDataSynchronisation"]
        ),
        .library(
            name: "SSSugarTesting",
            targets: ["SSSugarTesting"]
        ),
        .library(
            name: "SSSugarDynamic",
            type: .dynamic,
            targets: allTargets
        ),
        .executable(
            name: "SSSugarMacPG",
            targets: ["SSSugarMacPG"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.4.0"),
    ]
    + Additions.ForPackage.dependecies(),
    targets: [
        .target(
            name: "SSSugarCore",
            dependencies: [] + Additions.ForTarget.dependecies()
        ),
        .target(
            name: "SSSugarUIKit",
            dependencies: ["SSSugarCore"]
        ),
        .target(
            name: "SSSugarExecutors",
            dependencies: ["SSSugarCore"]
        ),
        .target(
            name: "SSSugarDataSynchronisation",
            dependencies: ["SSSugarExecutors"]
        ),
        .target(
            name: "SSSugarTesting",
            dependencies: ["SSSugarCore"]
        ),
        .target(
            name: "SSSugarMacPG",
            dependencies: [.product(name: "ArgumentParser", package: "swift-argument-parser")] + allMacTargets.map { .init(stringLiteral: $0) }
        ),
        .testTarget(
            name: "SSSugarTests",
            dependencies: allMacTargets.map { .init(stringLiteral: $0) }
        ),
        .testTarget(
            name: "SSSugarUIKitTests",
            dependencies: ["SSSugarUIKit", "SSSugarCore", "SSSugarTesting"]
        ),
    ]
)
