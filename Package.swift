// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

struct DBAdditions {
    struct ForPackage {
        static func dependencies() -> [Package.Dependency] {
            #if os(Linux)
            return [.package(name: "CSQLiteSS", url: "git@bitbucket.org:SiavA/csqlitess.git", from: "1.0.0")]
            #else
            return []
            #endif
        }
    }
    struct ForTarget {
        static func dependencies() -> [Target.Dependency] {
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
    "SSSugarDatabase",
    "SSSugarNetworking",
    "SSSugarDataSynchronisation",
    "SSSugarSwiftUI"
]

let allTargets = allMacTargets + [
    "SSSugarUIKit",
    "SSSugarTesting",
    "SSSugarExecutorsTesting",
    "SSSugarDatabaseTesting",
]

let package = Package(
    name: "SSSugar",
    platforms: [
        .macOS(.v11),
        .iOS(.v14)
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
            name: "SSSugarExecutorsAndTesting",
            targets: ["SSSugarExecutors", "SSSugarExecutorsTesting"]
        ),
        .library(
            name: "SSSugarDatabase",
            targets: ["SSSugarDatabase"]
        ),
        .library(
            name: "SSSugarDatabaseAndTesting",
            targets: ["SSSugarDatabase", "SSSugarDatabaseTesting"]
        ),
        .library(
            name: "SSSugarNetworking",
            targets: ["SSSugarNetworking"]
        ),
        .library(
            name: "SSSugarDataSynchronisation",
            targets: ["SSSugarDataSynchronisation"]
        ),
        .library(
            name: "SSSugarDataSynchronisationAndTesting",
            targets: ["SSSugarDataSynchronisation", "SSSugarDataSynchronisationTesting"]
        ),
        .library(
            name: "SSSugarSwiftUI",
            targets: ["SSSugarSwiftUI"]
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
    dependencies: DBAdditions.ForPackage.dependencies(),
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
            dependencies: ["SSSugarCore"] + DBAdditions.ForTarget.dependencies()
        ),
        .target(
            name: "SSSugarDatabaseTesting",
            dependencies: ["SSSugarCore", "SSSugarDatabase", "SSSugarTesting"] + DBAdditions.ForTarget.dependencies()
        ),
        .target(
            name: "SSSugarNetworking",
            dependencies: ["SSSugarCore"]
        ),
        .target(
            name: "SSSugarTesting",
            dependencies: ["SSSugarCore", "SSSugarExecutors"]
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
            name: "SSSugarSwiftUI",
            dependencies: ["SSSugarExecutors"]
        ),
        .target(
            name: "SSSugarMacPG",
            dependencies: allMacTargets.map { .init(stringLiteral: $0) }
        ),
        .testTarget(
            name: "SSSugarTests",
            dependencies: allTargets.map { .init(stringLiteral: $0) }
        ),
        .testTarget(
            name: "SSSugarUIKitTests",
            dependencies: ["SSSugarUIKit", "SSSugarCore", "SSSugarTesting"]
        ),
    ]
)
