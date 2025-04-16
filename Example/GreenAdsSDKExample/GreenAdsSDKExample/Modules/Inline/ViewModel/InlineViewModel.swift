//
//  InlineViewModel.swift
//  GreenAdsApp
//
//  Created by GreenAds on 06.11.2024.
//

final class InlineViewModel {
    private let inputModel: InlineInputModel

    init(inputModel: InlineInputModel) {
        self.inputModel = inputModel
    }
}

// MARK: - InlineViewModelProtocol
extension InlineViewModel: InlineViewModelProtocol {
    var isFixed: Bool {
        inputModel.isFixed
    }

    var blockId: Int {
        inputModel.blockId
    }

    var padId: Int {
        inputModel.padId
    }

    var isUIKit: Bool {
        inputModel.isUIKit
    }
}
