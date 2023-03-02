// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "smithy-codegenerator",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .executable(
            name: "SmithyCodeGenerator",
            targets: ["SmithyCodeGenerator"]),
        .plugin(name: "SmithyCodeGeneratorPlugin",
            targets: ["SmithyCodeGeneratorPlugin"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.4.0"),
        .package(url: "https://github.com/QiuZhiFei/swift-commands", from: "0.6.0")
    ],
    targets: [
        .executableTarget(
            name: "SmithyCodeGenerator",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "Commands", package: "swift-commands")
            ]),
        .plugin(
            name: "SmithyCodeGeneratorPlugin",
            capability: .buildTool(),
            dependencies: ["SmithyCodeGenerator"]
        ),
        .testTarget(
            name: "SmithyCodeGeneratorTests",
            dependencies: ["SmithyCodeGenerator"]),
    ]
)
