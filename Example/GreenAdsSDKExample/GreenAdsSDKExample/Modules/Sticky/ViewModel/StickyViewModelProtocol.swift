//
//  StickyViewModelProtocol.swift
//  GreenAdsApp
//
//  Created by GreenAds on 16.12.2024.
//

protocol StickyViewModelProtocol {
    var isFixed: Bool { get }
    var isUIKit: Bool { get }
    var isTop: Bool { get }
    var blockId: Int { get }
    var padId: Int { get }
}
