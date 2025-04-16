//
//  InterstitialProxy.swift
//  GreenAdsApp
//
//  Created by GreenAds on 25.02.2025.
//

import SwiftUI
import GreenAdsSDK

struct InterstitialProxy: View {
    @State private var isAd = false
    @State private var message: String?

    private let ad: GAInterstitialAd
    private let onEvent: ((GAInterstitialCoverEvent) -> Void)?

    var body: some View {
        Color
            .clear
            .gaInterstitialCover(isPresented: $isAd, ad: ad, onEvent: onEvent)
            .onAppear {
                isAd = true
            }
    }

    init(ad: GAInterstitialAd, onEvent: ((GAInterstitialCoverEvent) -> Void)? = nil) {
        self.ad = ad
        self.onEvent = onEvent
    }
}
