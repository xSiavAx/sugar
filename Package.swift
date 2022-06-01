// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

struct DBAdditions {
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
    "SSSugarExecutorsTesting",
    "SSSugarDatabase",
    "SSSugarDatabaseTesting",
    "SSSugarNetwork",
    "SSSugarNetworkTesting",
    "SSSugarTesting",
    "SSSugarKeyCoding",
    "SSSugarDataSynchronisation"
]

let allTargets = allMacTargets + ["SSSugarUIKit"]

let package = Package(
    name: "SSSugar",
    platforms: [
        .macOS(.v11),
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
    + DBAdditions.ForPackage.dependecies(),
    targets: [
        .target(
            name: "SSSugarCore",
            dependencies: []
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
            name: "SSSugarExecutorsTesting",
            dependencies: ["SSSugarCore", "SSSugarExecutors", "SSSugarTesting"]
        ),
        .target(
            name: "SSSugarDatabase",
            dependencies: ["SSSugarCore"] + DBAdditions.ForTarget.dependecies()
        ),
        .target(
            name: "SSSugarDatabaseTesting",
            dependencies: ["SSSugarCore", "SSSugarDatabase", "SSSugarTesting"] + DBAdditions.ForTarget.dependecies()
        ),
        .target(
            name: "SSSugarNetwork",
            dependencies: ["SSSugarCore"]
        ),
        .target(
            name: "SSSugarNetworkTesting",
            dependencies: ["SSSugarCore", "SSSugarNetwork", "SSSugarTesting"]
        ),
        .target(
            name: "SSSugarTesting",
            dependencies: ["SSSugarCore", "SSSugarExecutors"]
        ),
        .target(
            name: "SSSugarKeyCoding",
            dependencies: ["SSSugarCore", "SSSugarNetwork"]
        ),
        .target(
            name: "SSSugarDataSynchronisation",
            dependencies: ["SSSugarExecutors"]
        ),
        .target(
            name: "SSSugarDataSynchronisationTesting",
            dependencies: ["SSSugarExecutors", "SSSugarDataSynchronisation", "SSSugarTesting"]
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
