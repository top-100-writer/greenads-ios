//
//  InterstitialPickerViewController.swift
//  GreenAdsApp
//
//  Created by GreenAds on 16.01.2025.
//

import UIKit
import SwiftUI
import GreenAdsSDK

final class InterstitialPickerViewController: UIViewController {

    // MARK: Private properties

    private let viewModel: InterstitialPickerViewModelProtocol

    private lazy var segmentsPickerView: SegmentsPickerView = {
        let view = SegmentsPickerView(frame: .zero)
        view.delegate = self
        return view
    }()

    private var swiftUIView: UIView?

    // MARK: Internal methods

    convenience init(inputModel: InterstitialPickerInputModel) {
        let viewModel = InterstitialPickerViewModel(inputModel: inputModel)
        self.init(viewModel: viewModel)
        viewModel.view = self
    }

    init(viewModel: InterstitialPickerViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }

    override func loadView() {
        view = segmentsPickerView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - InterstitialPickerViewProtocol
extension InterstitialPickerViewController: InterstitialPickerViewProtocol {
    func showAd(_ ad: GAInterstitialAd, isUIKit: Bool) {
        showLoading(false)
        if isUIKit {
            ad.show(from: self, delegate: self)
        } else {
            let swiftView: some View = InterstitialProxy(ad: ad) { [weak self] event in
                guard let self else { return }
                switch event {
                case .dismiss:
                    self.swiftUIView?.removeFromSuperview()
                    self.swiftUIView = nil
                case .error(let error):
                    self.didFailLoadingInterstitialAd(blockId: ad.blockId, padId: ad.padId, error: error)
                    self.swiftUIView?.removeFromSuperview()
                    self.swiftUIView = nil
                default:
                    break
                }
            }
            segmentsPickerView.addSwiftUIView(swiftView, to: self) { swiftUIView in
                self.swiftUIView = swiftUIView
                view.addSubview(swiftUIView)

                NSLayoutConstraint.activate([
                    swiftUIView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    swiftUIView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                    swiftUIView.widthAnchor.constraint(equalTo: swiftUIView.heightAnchor),
                    swiftUIView.heightAnchor.constraint(equalToConstant: 1)
                ])
            }
        }
    }
    
    func didFailLoadingInterstitialAd(blockId: Int, padId: Int, error: any Error) {
        showAlert(
            with: "Ошибка",
            message: "Не удалось загрузить (\(blockId), \(padId)): \(error.localizedDescription)"
        )
        showLoading(false)
    }
}

// MARK: - GAInterstitialAdDelegate
extension InterstitialPickerViewController: GAInterstitialAdDelegate {
    func interstitialAdDidShow(_ interstitialAd: GAInterstitialAd) {
        swiftUIView?.removeFromSuperview()
        swiftUIView = nil
    }

    func interstitialAd(_ ad: GAInterstitialAd, didFailToShowWithError error: Error) {
        swiftUIView?.removeFromSuperview()
        swiftUIView = nil
        showAlert(
            with: "Ошибка",
            message: "Не удалось показать загруженный (\(ad.blockId), \(ad.padId)): \(error.localizedDescription)"
        )
    }
}

// MARK: - InterstitialPickerViewDelegate
extension InterstitialPickerViewController: SegmentsPickerViewDelegate {
    func segmentsPickerView(
        _ segmentsPickerView: SegmentsPickerView,
        didTapShowOptions options: [SegmentsPickerView.ViewModel.Option],
        blockId: String?,
        padId: String?
    ) {
        let blockIdInt = blockId.flatMap(Int.init)
        let padIdInt = padId.flatMap(Int.init)
        let isBlockIdWrong = blockId?.isEmpty == false && blockIdInt == nil
        let isPadIdWrong = padId?.isEmpty == false && padIdInt == nil

        if isBlockIdWrong, isPadIdWrong {
            return showAlert(with: "Неверные данные", message: "block_id и pad_id должны быть числами")
        } else if isBlockIdWrong {
            return showAlert(with: "Неверные данные", message: "block_id должен быть числом")
        } else if isPadIdWrong {
            return showAlert(with: "Неверные данные", message: "pad_id должен быть числом")
        }

        var isUIKit = true

        options.forEach { option in
            switch option {
            case .graphics(let graphics):
                isUIKit = graphics == .uiKit
            case .size, .position:
                return
            }
        }

        showLoading(true)
        viewModel.requestInterstitialBanner(blockId: blockIdInt, padId: padIdInt, isUIKit: isUIKit)
    }
}

// MARK: - Private
private extension InterstitialPickerViewController {
    func setupUI() {
        func setupNavigationBar() {
            title = "Interstitial"
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.label]
        }

        func setupView() {
            segmentsPickerView.viewModel = .init(
                idsModel: .init(blockId: viewModel.blockId, padId: viewModel.padId),
                options: [.graphics(.uiKit)]
            )
        }

        setupNavigationBar()
        setupView()
    }

    func showLoading(_ isLoading: Bool) {
        DispatchQueue.main.async {
            self.segmentsPickerView.updateInteractionEnabled(!isLoading)

            var rightItem: UIBarButtonItem?
            if isLoading {
                let indicatorView = UIActivityIndicatorView(style: .medium)
                indicatorView.startAnimating()
                rightItem = .init(customView: indicatorView)
            }
            self.navigationItem.setRightBarButton(rightItem, animated: true)
        }
    }
}
