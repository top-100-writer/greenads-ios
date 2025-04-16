//
//  StickyViewModel.swift
//  GreenAdsApp
//
//  Created by GreenAds on 16.12.2024.
//

final class StickyViewModel {
    private let inputModel: StickyInputModel

    init(inputModel: StickyInputModel) {
        self.inputModel = inputModel
    }
}

// MARK: - StickyViewModelProtocol
extension StickyViewModel: StickyViewModelProtocol {
    var isFixed: Bool {
        inputModel.isFixed
    }

    var isUIKit: Bool {
        inputModel.isUIKit
    }

    var isTop: Bool {
        inputModel.isTop
    }

    var blockId: Int {
        inputModel.blockId
    }

    var padId: Int {
        inputModel.padId
    }
}
