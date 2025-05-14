// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GreenAdsSDK",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "GreenAdsSDK",
            targets: ["GreenAdsSDK"]
        ),
    ],
    targets: [
        .binaryTarget(
            name: "GreenAdsSDK", 
            url: "https://github.com/top-100-writer/greenads-ios/releases/download/1.0.4/GreenAdsSDK.xcframework.zip", 
            checksum: "fce894b045792af8e5ea8c6c8b58fe8617767d33c8d210269a45a36f2a256705"
        )
    ]
)
