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
            url: "https://github.com/top-100-writer/greenads-ios/releases/download/1.0.1/GreenAdsSDK.xcframework.zip", 
            checksum: "d0a41963d3abf6b92b8e36dbb42da482c8ec07ca078f3217ee99b82dd207824e"
        )
    ]
)
