//
//  InterstitialPickerViewModelProtocol.swift
//  GreenAdsApp
//
//  Created by GreenAds on 16.01.2025.
//

protocol InterstitialPickerViewModelProtocol: AnyObject {
    var view: InterstitialPickerViewProtocol! { get set }
    var blockId: Int { get }
    var padId: Int { get }

    func requestInterstitialBanner(blockId: Int?, padId: Int?, isUIKit: Bool)
}
