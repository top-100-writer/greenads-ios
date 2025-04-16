//
//  InlineViewModelProtocol.swift
//  GreenAdsApp
//
//  Created by GreenAds on 06.11.2024.
//

protocol InlineViewModelProtocol: AnyObject {
    var isFixed: Bool { get }
    var blockId: Int { get }
    var padId: Int { get }
    var isUIKit: Bool { get }
}
