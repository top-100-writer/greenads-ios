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
            url: "https://github.com/top-100-writer/greenads-ios/releases/download/1.0.0/GreenAdsSDK.xcframework.zip", 
            checksum: "8fa4b9e8bc03a72908f467774cb5a88a9c0d2ac08607958fc93070b750753c5d"
        )
    ]
)