// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "proton",
    platforms: [
        .macOS(.v10_15),
    ],
    products: [
        .library(
            name: "proton-backend-cocoa",
            type: .static,
            targets: ["proton-backend-cocoa"]),

        .executable(name: "protontestapp",
                    targets: ["protontestapp"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "proton-backend-cocoa",
            dependencies: ["protonObjC"]),
        .testTarget(
            name: "proton-backend-cocoaTests",
            dependencies: ["proton-backend-cocoa"]),
        .target(
            name: "protontestapp",
            dependencies: ["proton-backend-cocoa"]),
        .target(
           name: "protonObjC",
           dependencies: [],
           cSettings: [
              .headerSearchPath("Internal"),
           ]
        ),
    ],
    cxxLanguageStandard: CXXLanguageStandard.cxx11
)
