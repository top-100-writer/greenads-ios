//
//  StickyViewController.swift
//  GreenAdsApp
//
//  Created by GreenAds on 16.12.2024.
//

import UIKit
import GreenAdsSDK

struct StickyInputModel {
    let isFixed: Bool
    let isUIKit: Bool
    let isTop: Bool
    var blockId: Int = CommonConstants.sticky.0
    var padId: Int = CommonConstants.sticky.1
}

final class StickyViewController: UIViewController {

    // MARK: Private properties

    private let viewModel: StickyViewModelProtocol

    private lazy var stickyView = StickyView()

    // MARK: Internal methods

    convenience init(inputModel: StickyInputModel) {
        self.init(viewModel: StickyViewModel(inputModel: inputModel))
    }

    init(viewModel: StickyViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }

    override func loadView() {
        view = stickyView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard viewModel.isTop else { return }
        navigationController?.navigationBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard viewModel.isTop else { return }
        navigationController?.navigationBar.isHidden = false
    }
}

// MARK: - GAStickyBannerViewDelegate
extension StickyViewController: GAStickyBannerViewDelegate {
    func stickyBannerView(
        _ adBannerView: GAStickyBannerView,
        withInputModel inputModel: GAStickyBannerInputModel,
        didFailLoadingAdWith error: any Error
    ) {
        showAlert(
            with: "Ошибка",
            message: "Не удалось загрузить (\(inputModel.blockId), \(inputModel.padId)): \(error.localizedDescription)"
        )
    }
}

// MARK: - Private
private extension StickyViewController {
    func setupUI() {
        func setupTitle() {
            title = "\(viewModel.isFixed ? "Usual" : "Adaptive") \(viewModel.isTop ? "top" : "bottom") sticky"
        }

        func showBanners() {
            stickyView.showBanner(
                .init(blockId: viewModel.blockId, padId: viewModel.padId),
                fixed: viewModel.isFixed,
                uiKit: viewModel.isUIKit,
                top: viewModel.isTop,
                parent: self
            )
        }

        setupTitle()
        showBanners()
    }
}
