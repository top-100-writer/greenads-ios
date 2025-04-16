//
//  PickerViewController.swift
//  GreenAdsApp
//
//  Created by GreenAds on 16.01.2025.
//

import UIKit

final class PickerViewController: UIViewController {
    // MARK: Private properties

    private let viewModel: PickerViewModelProtocol

    // MARK: Internal methods

    convenience init(inputModel: PickerInputModel) {
        let viewModel = PickerViewModel(inputModel: inputModel)
        self.init(viewModel: viewModel)
    }

    init(viewModel: PickerViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }

    override func loadView() {
        view = createView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - ButtonsPickerViewDelegate
extension PickerViewController: ButtonsPickerViewDelegate {
    func buttonsPickerView(
        _ buttonsPickerView: ButtonsPickerView,
        didTapOptionWithTitle title: String,
        blockId: String?,
        padId: String?
    ) {
        guard let (blockId, padId) = fetchIdsWithAlert(blockId: blockId, padId: padId) else {
            return
        }
        guard case .buttons(let buttons) = viewModel.inputModel.options,
              let option = buttons.first(where: { $0.title == title })
        else {
            return showAlert(with: "Неверные данные", message: "Нет такой опции")
        }

        switch option {
        case .picker(let input):
            let model: PickerInputModel
            switch input {
            case .main:
                model = input
            case let .inline(block, pad):
                model = .inline(blockId: blockId ?? block, padId: padId ?? pad)
            case let .sticky(block, pad):
                model = .sticky(blockId: blockId ?? block, padId: padId ?? pad)
            }

            show(PickerViewController(inputModel: model))
        case .interstitial(var input):
            input.blockId = blockId ?? input.blockId
            input.padId = padId ?? input.padId
            show(InterstitialPickerViewController(inputModel: input))
        }
    }
}

// MARK: - SegmentsPickerViewDelegate
extension PickerViewController: SegmentsPickerViewDelegate {
    func segmentsPickerView(
        _ segmentsPickerView: SegmentsPickerView,
        didTapShowOptions options: [SegmentsPickerView.ViewModel.Option],
        blockId: String?,
        padId: String?
    ) {
        guard let (blockId, padId) = fetchIdsWithAlert(blockId: blockId, padId: padId) else {
            return
        }

        var isFixed = false
        var isTop = false
        var isUIKit = false

        options.forEach { option in
            switch option {
            case .size(let size):
                isFixed = size == .usual
            case .position(let position):
                isTop = position == .top
            case .graphics(let graph):
                isUIKit = graph == .uiKit
            }
        }

        switch viewModel.inputModel {
        case .main:
            assertionFailure("Main is not segments, it's buttons")
            break
        case let .inline(block, pad):
            let input = InlineInputModel(
                isFixed: isFixed,
                isUIKit: isUIKit,
                blockId: blockId ?? block,
                padId: padId ?? pad
            )
            show(InlineViewController(inputModel: input))
        case let .sticky(block, pad):
            let input = StickyInputModel(
                isFixed: isFixed,
                isUIKit: isUIKit,
                isTop: isTop,
                blockId: blockId ?? block,
                padId: padId ?? pad
            )
            show(StickyViewController(inputModel: input))
        }
    }
}

// MARK: - Private
private extension PickerViewController {
    func setupUI() {
        func setupNavigationBar() {
            title = viewModel.inputModel.navigationTitle
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.label]
        }

        setupNavigationBar()
    }

    func fetchIdsWithAlert(blockId: String?, padId: String?) -> (Int?, Int?)? {
        let blockIdInt = blockId.flatMap(Int.init)
        let padIdInt = padId.flatMap(Int.init)
        let isBlockIdWrong = blockId?.isEmpty == false && blockIdInt == nil
        let isPadIdWrong = padId?.isEmpty == false && padIdInt == nil

        if isBlockIdWrong, isPadIdWrong {
            showAlert(with: "Неверные данные", message: "block_id и pad_id должны быть числами")
            return nil
        } else if isBlockIdWrong {
            showAlert(with: "Неверные данные", message: "block_id должен быть числом")
            return nil
        } else if isPadIdWrong {
            showAlert(with: "Неверные данные", message: "pad_id должен быть числом")
            return nil
        }
        return (blockIdInt, padIdInt)
    }

    func show(_ vc: UIViewController) {
        if let navigationController {
            navigationController.pushViewController(vc, animated: true)
        } else {
            present(vc, animated: true)
        }
    }

    func createView() -> UIView {
        let inputModel = viewModel.inputModel
        let idsModel = IdsFieldsView.ViewModel(
            blockId: inputModel.blockId,
            padId: inputModel.padId
        )
        switch viewModel.inputModel.options {
        case .buttons(let buttons):
            let view = ButtonsPickerView(frame: .zero)
            view.delegate = self
            view.viewModel = ButtonsPickerView.ViewModel(
                idsModel: idsModel,
                buttons: buttons.map { .init(title: $0.title) }
            )
            return view
        case .segments(let segments):
            let view = SegmentsPickerView(frame: .zero)
            view.delegate = self
            view.viewModel = .init(
                idsModel: idsModel,
                options: segments.map { segment in
                    switch segment {
                    case .position:
                            .position(.top)
                    case .size:
                            .size(.usual)
                    case .graphics:
                            .graphics(.uiKit)
                    }
                }
            )
            return view
        }
    }
}
