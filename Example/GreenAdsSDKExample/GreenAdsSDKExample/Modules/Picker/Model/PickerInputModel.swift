//
//  PickerViewController+Modules.swift
//  GreenAdsApp
//
//  Created by GreenAds on 16.01.2025.
//

enum PickerOptions {
    enum Button {
        case picker(PickerInputModel)
        case interstitial(InterstitialPickerInputModel)

        var title: String {
            switch self {
            case .picker(let input):
                switch input {
                case .main:
                    "Main"
                case .inline:
                    "Inline"
                case .sticky:
                    "Sticky"
                }
            case .interstitial:
                "Interstitial"
            }
        }
    }

    enum Segment {
        case size, position, graphics
    }

    case segments([Segment])
    case buttons([Button])
}

enum PickerInputModel {
    case main
    case inline(blockId: Int = CommonConstants.inline.0, padId: Int = CommonConstants.inline.1)
    case sticky(blockId: Int = CommonConstants.sticky.0, padId: Int = CommonConstants.sticky.1)

    var navigationTitle: String {
        switch self {
        case .main:
            "Main Scene"
        case .inline:
            "Inline banner"
        case .sticky:
            "Sticky banner"
        }
    }

    var options: PickerOptions {
        switch self {
        case .main:
                .buttons([.inline(), .sticky()].map { .picker($0) } + [.interstitial(.init())])
        case .inline:
                .segments([.size, .graphics])
        case .sticky:
                .segments([.size, .graphics, .position])
        }
    }

    var blockId: Int? {
        switch self {
        case .main:
            CommonConstants.default?.0
        case .inline(let blockId, _), .sticky(let blockId, _):
            blockId
        }
    }

    var padId: Int? {
        switch self {
        case .main:
            CommonConstants.default?.1
        case .inline(_, let padId), .sticky(_, let padId):
            padId
        }
    }
}
