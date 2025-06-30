// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "Tentacle",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
    ],
    products: [
        .library(name: "Tentacle", targets: ["Tentacle"]),
        .executable(name: "TentacleCLI", targets: ["TentacleCLI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Moya/Moya.git", .upToNextMajor(from: "15.0.0"))
    ],
    targets: [
        .target(
            name: "Tentacle",
            dependencies: [.product(name: "ReactiveMoya", package: "Moya")]),
        .executableTarget(name: "TentacleCLI", dependencies: ["Tentacle"]),
    ]
)
