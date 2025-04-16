//
//  InterstitialPickerViewModel.swift
//  GreenAdsApp
//
//  Created by GreenAds on 16.01.2025.
//

import GreenAdsSDK

final class InterstitialPickerViewModel: NSObject {
    
    // MARK: Internal properties

    unowned var view: InterstitialPickerViewProtocol!

    // MARK: Private properties

    private var inputModel: InterstitialPickerInputModel
    private var interstitialAd: GAInterstitialAd?

    private var isUIKit: Bool = true

    private lazy var interstitialAdLoader: GAInterstitialAdLoader = {
        let loader = GAInterstitialAdLoader()
        loader.delegate = self
        return loader
    }()

    // MARK: Internal methods

    init(inputModel: InterstitialPickerInputModel) {
        self.inputModel = inputModel
    }
}

// MARK: - HomeViewModelProtocol
extension InterstitialPickerViewModel: InterstitialPickerViewModelProtocol {
    var blockId: Int {
        inputModel.blockId
    }

    var padId: Int {
        inputModel.padId
    }

    func requestInterstitialBanner(blockId: Int?, padId: Int?, isUIKit: Bool) {
        self.isUIKit = isUIKit
        inputModel.blockId = blockId ?? self.blockId
        inputModel.padId = padId ?? self.padId
        let configuration = GAAdRequestConfiguration(
            blockId: self.blockId,
            padId: self.padId
        )
        interstitialAdLoader.loadAd(with: configuration)
    }
}

// MARK: - GAInterstitialAdLoaderDelegate
extension InterstitialPickerViewModel: GAInterstitialAdLoaderDelegate {
    func interstitialAdLoader(_ adLoader: GAInterstitialAdLoader, didLoad interstitialAd: GAInterstitialAd) {
        view.showAd(interstitialAd, isUIKit: isUIKit)
    }

    func interstitialAdLoader(_ adLoader: GAInterstitialAdLoader, didFailToLoadWithError error: Error) {
        view.didFailLoadingInterstitialAd(blockId: blockId, padId: padId, error: error)
    }
}
