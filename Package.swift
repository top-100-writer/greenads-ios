// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GreenAdsSDK",
    platforms: [
        .iOS(.v12),
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
            url: "https://github.com/top-100-writer/greenads-ios/releases/download/1.0.2/GreenAdsSDK.xcframework.zip", 
            checksum: "100ee75f7a6300d720570a6722b130c1508b3fc213bd6ec15f5cae8fe6c74bda"
        )
    ]
)
