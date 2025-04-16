//
//  PickerViewModel.swift
//  GreenAdsApp
//
//  Created by GreenAds on 16.01.2025.
//

final class PickerViewModel {
    let inputModel: PickerInputModel

    init(inputModel: PickerInputModel) {
        self.inputModel = inputModel
    }
}

// MARK: - PickerViewModelProtocol
extension PickerViewModel: PickerViewModelProtocol {
}
