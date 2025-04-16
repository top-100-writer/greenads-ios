//
//  IdsFieldsView.swift
//  GreenAdsApp
//
//  Created by GreenAds on 01.02.2025.
//

import UIKit

protocol IdsFieldsViewDelegate: AnyObject {
    func idsFieldsViewDidTapReset(_ idsFieldsView: IdsFieldsView)
}

final class IdsFieldsView: UIView {
    struct ViewModel {
        var blockId: Int?
        var padId: Int?
    }

    // MARK: Internal properties

    var viewModel = ViewModel() {
        didSet {
            updateUI()
        }
    }

    weak var delegate: IdsFieldsViewDelegate?

    let blockIdField = UITextField()
    let padIdField = UITextField()

    var isEnabled: Bool = true {
        didSet {
            blockIdField.isEnabled = isEnabled
            padIdField.isEnabled = isEnabled
        }
    }

    // MARK: Private properties

    private let blockIdLabel = UILabel()
    private let padIdLabel = UILabel()
    private let resetButton = UIButton()

    // MARK: Internal methods

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
}

private extension IdsFieldsView {
    enum Constants {
        static let controlHeight: CGFloat = 52
        static let controlRadius: CGFloat = 6
        static let vOffset: CGFloat = 5
        static let hOffset: CGFloat = 16
    }

    func setupUI() {
        func setupBlockIdLabel() {
            addSubview(blockIdLabel)

            blockIdLabel.translatesAutoresizingMaskIntoConstraints = false
            blockIdLabel.text = "Block Id"
            blockIdLabel.font = .preferredFont(forTextStyle: .headline)
            blockIdLabel.textAlignment = .center

            NSLayoutConstraint.activate([
                blockIdLabel.topAnchor.constraint(equalTo: topAnchor),
                blockIdLabel.rightAnchor.constraint(equalTo: centerXAnchor, constant: -Constants.hOffset),
                blockIdLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: Constants.hOffset),
            ])
        }

        func setupBlockIdField() {
            addSubview(blockIdField)

            blockIdField.translatesAutoresizingMaskIntoConstraints = false
            blockIdField.placeholder = "012345678"
            blockIdField.backgroundColor = .systemBackground
            blockIdField.layer.borderWidth = 1
            blockIdField.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
            blockIdField.layer.cornerRadius = Constants.controlRadius
            blockIdField.clipsToBounds = true
            blockIdField.textAlignment = .center
            blockIdField.keyboardType = .numberPad
            blockIdField.autocorrectionType = .no
            blockIdField.autocapitalizationType = .none

            NSLayoutConstraint.activate([
                blockIdField.topAnchor.constraint(equalTo: blockIdLabel.bottomAnchor, constant: Constants.vOffset),
                blockIdField.rightAnchor.constraint(equalTo: centerXAnchor, constant: -Constants.hOffset),
                blockIdField.leftAnchor.constraint(equalTo: leftAnchor, constant: Constants.hOffset),
                blockIdField.heightAnchor.constraint(equalToConstant: Constants.controlHeight),
            ])
        }

        func setupPadIdLabel() {
            addSubview(padIdLabel)

            padIdLabel.translatesAutoresizingMaskIntoConstraints = false
            padIdLabel.text = "Pad Id"
            padIdLabel.textAlignment = .center
            padIdLabel.font = .preferredFont(forTextStyle: .headline)

            NSLayoutConstraint.activate([
                padIdLabel.topAnchor.constraint(equalTo: blockIdLabel.topAnchor),
                padIdLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -Constants.hOffset),
                padIdLabel.leftAnchor.constraint(equalTo: centerXAnchor, constant: Constants.hOffset),
            ])
        }

        func setupPadIdField() {
            addSubview(padIdField)

            padIdField.translatesAutoresizingMaskIntoConstraints = false
            padIdField.placeholder = "012345678"
            padIdField.backgroundColor = .systemBackground
            padIdField.layer.borderWidth = 1
            padIdField.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
            padIdField.layer.cornerRadius = Constants.controlRadius
            padIdField.clipsToBounds = true
            padIdField.textAlignment = .center
            padIdField.keyboardType = .numberPad
            padIdField.autocorrectionType = .no
            padIdField.autocapitalizationType = .none

            NSLayoutConstraint.activate([
                padIdField.topAnchor.constraint(equalTo: blockIdField.topAnchor),
                padIdField.rightAnchor.constraint(equalTo: rightAnchor, constant: -Constants.hOffset),
                padIdField.leftAnchor.constraint(equalTo: centerXAnchor, constant: Constants.hOffset),
                padIdField.heightAnchor.constraint(equalTo: blockIdField.heightAnchor)
            ])
        }

        func setupResetButton() {
            addSubview(resetButton)

            resetButton.translatesAutoresizingMaskIntoConstraints = false
            resetButton.setTitle("Reset", for: .normal)
            resetButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
            resetButton.backgroundColor = .black.withAlphaComponent(0.1)
            resetButton.setTitleColor(.label, for: .normal)
            resetButton.clipsToBounds = true
            resetButton.layer.cornerRadius = Constants.controlRadius
            resetButton.addTarget(self, action: #selector(didTapResetButton), for: .touchUpInside)

            NSLayoutConstraint.activate([
                resetButton.topAnchor.constraint(equalTo: blockIdField.bottomAnchor, constant: 2 * Constants.vOffset),
                resetButton.leftAnchor.constraint(equalTo: blockIdField.leftAnchor),
                resetButton.rightAnchor.constraint(equalTo: padIdField.rightAnchor),
                resetButton.bottomAnchor.constraint(equalTo: bottomAnchor),
                resetButton.heightAnchor.constraint(equalToConstant: Constants.controlHeight)
            ])
        }

        setupBlockIdLabel()
        setupBlockIdField()
        setupPadIdLabel()
        setupPadIdField()
        setupResetButton()
    }

    func updateUI() {
        blockIdField.text = viewModel.blockId.map(String.init)
        padIdField.text = viewModel.padId.map(String.init)
    }

    @objc func didTapResetButton() {
        delegate?.idsFieldsViewDidTapReset(self)
    }
}
