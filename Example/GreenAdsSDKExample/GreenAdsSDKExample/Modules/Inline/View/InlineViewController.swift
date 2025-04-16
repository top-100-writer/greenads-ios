//
//  InlineViewController.swift
//  GreenAdsApp
//
//  Created by GreenAds on 06.11.2024.
//

import UIKit
import GreenAdsSDK

struct InlineInputModel {
    let isFixed: Bool
    let isUIKit: Bool
    var blockId: Int = CommonConstants.inline.0
    var padId: Int = CommonConstants.inline.1
}

final class InlineViewController: UIViewController {

    // MARK: Private properties

    private let viewModel: InlineViewModelProtocol

    private lazy var inlineView = InlineView()

    // MARK: Internal methods

    convenience init(inputModel: InlineInputModel) {
        self.init(viewModel: InlineViewModel(inputModel: inputModel))
    }

    init(viewModel: InlineViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }

    override func loadView() {
        view = inlineView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - GAAdBannerViewDelegate
extension InlineViewController: GAInlineBannerViewDelegate {
    func inlineBannerView(
        _ adBannerView: GAInlineBannerView,
        withInputModel inputModel: GAInlineBannerInputModel,
        didFailLoadingAdWith error: any Error
    ) {
        inlineView.hideBanner()
        showAlert(
            with: "Ошибка",
            message: """
                Не удалось загрузить (\(inputModel.blockId), \(inputModel.padId)):
                \(error.localizedDescription)
            """
        )
    }
}

// MARK: - Private
private extension InlineViewController {
    func setupUI() {
        func setupTitle() {
            title = "\(viewModel.isFixed ? "Usual" : "Adaptive") inline"
        }

        func showBanners() {
            inlineView.showBanner(
                with: .init(blockId: viewModel.blockId, padId: viewModel.padId),
                fixed: viewModel.isFixed,
                uiKit: viewModel.isUIKit,
                parent: self
            )
        }

        setupTitle()
        showBanners()
    }
}
