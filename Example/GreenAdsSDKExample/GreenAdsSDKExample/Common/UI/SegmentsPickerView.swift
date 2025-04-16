//
//  SegmentsPickerView.swift
//  GreenAdsApp
//
//  Created by GreenAds on 07.02.2025.
//

import UIKit

protocol SegmentsPickerViewDelegate: AnyObject {
    func segmentsPickerView(
        _ segmentsPickerView: SegmentsPickerView,
        didTapShowOptions options: [SegmentsPickerView.ViewModel.Option],
        blockId: String?,
        padId: String?
    )
}

final class SegmentsPickerView: UIView {
    // MARK: Internal properties

    struct ViewModel {
        enum Option: Hashable {
            case size(Size), position(Position), graphics(Graphics)
        }

        enum Size: String, CaseIterable {
            case usual, adaptive
        }

        enum Position: String, CaseIterable {
            case top, bottom
        }

        enum Graphics: String, CaseIterable {
            case uiKit = "uikit", swiftUI = "swiftui"

            var displayValue: String {
                switch self {
                case .uiKit:
                    "UIKit"
                case .swiftUI:
                    "SwiftUI"
                }
            }
        }

        private(set) var idsModel = IdsFieldsView.ViewModel()
        var options: [Option] = []
    }

    var viewModel = ViewModel() {
        didSet {
            updateUI()
        }
    }

    weak var delegate: SegmentsPickerViewDelegate?

    // MARK: Private properties

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let idsView = IdsFieldsView()
    private let optionsStackView = UIStackView()
    private var showButton: UIView = UIButton()

    private var segments: [ViewModel.Option: UISegmentedControl] = [:]

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

    func updateInteractionEnabled(_ isEnabled: Bool) {
        segments.values.forEach { $0.isEnabled = isEnabled }
        showButton.isUserInteractionEnabled = isEnabled
        idsView.isEnabled = isEnabled
    }

    func updateButton(with view: UIView) {
        showButton = view
        optionsStackView.arrangedSubviews.last?.removeFromSuperview()
        optionsStackView.addArrangedSubview(view)
    }
}

// MARK: - IdsFieldsViewDelegate
extension SegmentsPickerView: IdsFieldsViewDelegate {
    func idsFieldsViewDidTapReset(_ idsFieldsView: IdsFieldsView) {
        idsView.viewModel = viewModel.idsModel
    }
}

// MARK: - Private

private extension SegmentsPickerView {
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

        func setupOptionsStackView() {
            contentView.addSubview(optionsStackView)

            optionsStackView.translatesAutoresizingMaskIntoConstraints = false
            optionsStackView.axis = .vertical
            optionsStackView.spacing = Constants.vOffset

            NSLayoutConstraint.activate([
                optionsStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
                optionsStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
                optionsStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -Constants.vOffset),
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
                idsView.bottomAnchor.constraint(equalTo: optionsStackView.topAnchor, constant: -Constants.vOffset),
            ])
        }

        func setupShowButton() {
            let showButton = UIButton()
            showButton.translatesAutoresizingMaskIntoConstraints = false
            showButton.setTitle("Show", for: .normal)
            showButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
            showButton.backgroundColor = .systemBlue
            showButton.setTitleColor(.label, for: .normal)
            showButton.clipsToBounds = true
            showButton.layer.cornerRadius = Constants.buttonCornerRadius
            showButton.addTarget(self, action: #selector(didTapShowButton), for: .touchUpInside)

            optionsStackView.addArrangedSubview(showButton)
            showButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight).isActive = true
            self.showButton = showButton
        }

        setupView()
        setupScrollView()
        setupContentView()
        setupOptionsStackView()
        setupIdsView()
        setupShowButton()

        hideKeyboardWhenTapped()
    }

    func addSegment(forOption option: ViewModel.Option) {
        let segmentedControl = UISegmentedControl()
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.setTitleTextAttributes(
            [.font: UIFont.boldSystemFont(ofSize: 16)],
            for: .normal
        )
        segments[option] = segmentedControl
        let segments: [String]
        let selected: String
        switch option {
        case .position(let pos):
            segments = ViewModel.Position.allCases.map { $0.rawValue }
            selected = pos.rawValue
        case .size(let size):
            segments = ViewModel.Size.allCases.map { $0.rawValue }
            selected = size.rawValue
        case .graphics(let graph):
            segments = ViewModel.Graphics.allCases.map { $0.displayValue }
            selected = graph.displayValue
        }
        segments.enumerated().forEach { index, elem in
            segmentedControl.insertSegment(
                withTitle: elem.prefix(1).capitalized + elem.dropFirst(),
                at: index,
                animated: false
            )
        }
        if let index = segments.firstIndex(of: selected),
           (0..<segmentedControl.numberOfSegments).contains(index)
        {
            segmentedControl.selectedSegmentIndex = index
        }
        optionsStackView.addArrangedSubview(segmentedControl)

        segmentedControl.heightAnchor.constraint(equalToConstant: Constants.buttonHeight).isActive = true
    }

    func updateUI() {
        idsView.viewModel = viewModel.idsModel
        // Clear stack view
        optionsStackView.subviews.forEach { view in
            optionsStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        // Add segments to stack view
        segments.removeAll()
        viewModel.options.forEach { option in
            addSegment(forOption: option)
        }

        // Add button to stack view
        optionsStackView.addArrangedSubview(showButton)
    }

    @objc func didTapShowButton() {
        let options: [ViewModel.Option] = viewModel.options.compactMap { option in
            guard let segment = segments[option],
                  let raw = segment.titleForSegment(at: segment.selectedSegmentIndex)?.lowercased()
            else {
                assertionFailure("Segment \(option) not found")
                return nil
            }

            switch option {
            case .position:
                return ViewModel.Position(rawValue: raw).map { .position($0) }
            case .size:
                return ViewModel.Size(rawValue: raw).map { .size($0) }
            case .graphics:
                return ViewModel.Graphics(rawValue: raw).map { .graphics($0) }
            }
        }
        delegate?.segmentsPickerView(
            self,
            didTapShowOptions: options, // TODO: опции
            blockId: idsView.blockIdField.text,
            padId: idsView.padIdField.text
        )
    }
}
