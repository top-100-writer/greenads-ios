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
            url: "https://github.com/top-100-writer/greenads-ios/releases/download/1.0.3/GreenAdsSDK.xcframework.zip", 
            checksum: "d82318bd26acd873f04a0ce5ef24e4c001761cd7bf5e2f07436e5bd9ca893afd"
        )
    ]
)
