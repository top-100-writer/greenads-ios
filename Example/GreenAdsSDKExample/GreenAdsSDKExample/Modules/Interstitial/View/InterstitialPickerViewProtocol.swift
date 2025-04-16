//
//  InterstitialPickerViewProtocol.swift
//  GreenAdsApp
//
//  Created by GreenAds on 16.01.2025.
//

import UIKit
import GreenAdsSDK

protocol InterstitialPickerViewProtocol: AnyObject {
    func didFailLoadingInterstitialAd(blockId: Int, padId: Int, error: Error)
    func showAd(_ ad: GAInterstitialAd, isUIKit: Bool)
}
