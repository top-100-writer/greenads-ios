//
//  ButtonsPickerView.swift
//  GreenAdsApp
//
//  Created by GreenAds on 16.01.2025.
//

import UIKit

protocol ButtonsPickerViewDelegate: AnyObject {
    func buttonsPickerView(
        _ buttonsPickerView: ButtonsPickerView,
        didTapOptionWithTitle title: String,
        blockId: String?,
        padId: String?
    )
}

final class ButtonsPickerView: UIView {

    // MARK: Internal properties

    struct ViewModel {
        struct Button {
            let title: String
        }

        private(set) var idsModel = IdsFieldsView.ViewModel()
        var buttons: [Button] = []
    }

    var viewModel = ViewModel() {
        didSet {
            updateUI()
        }
    }

    weak var delegate: ButtonsPickerViewDelegate?

    // MARK: Private properties

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let buttonsStackView = UIStackView()
    private let idsView = IdsFieldsView()

    // MARK: Internal methods

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
}

// MARK: - IdsFieldsViewDelegate
extension ButtonsPickerView: IdsFieldsViewDelegate {
    func idsFieldsViewDidTapReset(_ idsFieldsView: IdsFieldsView) {
        idsView.viewModel = viewModel.idsModel
    }
}

// MARK: - Private

private extension ButtonsPickerView {
    enum Constants {
        static let hOffset: CGFloat = 20
        static let vOffset: CGFloat = 16
        static let buttonHeight: CGFloat = 52
        static let buttonCornerRadius: CGFloat = 6
    }

    func setupUI() {
        func setupView() {
            backgroundColor = .systemBackground
        }

        func setupScrollView() {
            addSubview(scrollView)

            scrollView.backgroundColor = .systemBackground
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.indicatorStyle = .white

            NSLayoutConstraint.activate([
                scrollView.centerXAnchor.constraint(equalTo: centerXAnchor),
                scrollView.widthAnchor.constraint(equalTo: widthAnchor),
                scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            ])
        }

        func setupContentView() {
            scrollView.addSubview(contentView)

            contentView.translatesAutoresizingMaskIntoConstraints = false
            let heightC = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
            heightC.priority = .defaultLow

            NSLayoutConstraint.activate([
                contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -2 * Constants.hOffset),
                contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                contentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: Constants.hOffset),
                contentView.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -Constants.hOffset),
                heightC
            ])
        }

        func setupButtonsStackView() {
            contentView.addSubview(buttonsStackView)

            buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
            buttonsStackView.axis = .vertical
            buttonsStackView.spacing = Constants.vOffset

            NSLayoutConstraint.activate([
                buttonsStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
                buttonsStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
                buttonsStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -Constants.vOffset),
            ])
        }

        func setupIdsView() {
            contentView.addSubview(idsView)

            idsView.translatesAutoresizingMaskIntoConstraints = false
            idsView.delegate = self

            NSLayoutConstraint.activate([
                idsView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.vOffset),
                idsView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
                idsView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
                idsView.bottomAnchor.constraint(equalTo: buttonsStackView.topAnchor, constant: -Constants.vOffset),
            ])
        }

        setupView()
        setupScrollView()
        setupContentView()
        setupButtonsStackView()
        setupIdsView()

        hideKeyboardWhenTapped()
    }

    func addButton(withTitle title: String) {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.label, for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = Constants.buttonCornerRadius
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)

        buttonsStackView.addArrangedSubview(button)
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: Constants.buttonHeight)
        ])
    }

    func updateUI() {
        buttonsStackView.subviews.forEach { view in
            buttonsStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        viewModel.buttons.forEach { option in
            addButton(withTitle: option.title)
        }

        idsView.viewModel = viewModel.idsModel
    }

    @objc func didTapButton(_ button: UIButton) {
        guard let option = viewModel.buttons.first(where: { $0.title == button.currentTitle }) else { return }
        delegate?.buttonsPickerView(
            self,
            didTapOptionWithTitle: option.title,
            blockId: idsView.blockIdField.text,
            padId: idsView.padIdField.text
        )
    }
}
