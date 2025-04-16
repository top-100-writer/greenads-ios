//
//  InlineView.swift
//  GreenAdsApp
//
//  Created by GreenAds on 06.11.2024.
//

import UIKit
import GreenAdsSDK
import SwiftUI

final class InlineView: UIView {
    // MARK: Private properties

    private let scrollView = UIScrollView()
    private let contentStackView = UIStackView()

    private var bannerView: UIView?

    // MARK: Internal methods

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    func showBanner(
        with inputModel: GAInlineBannerInputModel,
        fixed isFixed: Bool,
        uiKit isUIKit: Bool,
        parent: InlineViewController
    ) {
        addSpacingText()
        let size: GASize = isFixed ? .fixed : .adaptiveWidth
        if isUIKit {
            addUIKitBanner(
                with: inputModel,
                size: size,
                parent: parent
            )
        } else {
            addSwiftUIBanner(
                with: inputModel,
                size: size,
                parent: parent
            )
        }

        addSpacingText()
    }

    func hideBanner() {
        bannerView?.isHidden = true
    }
}

// MARK: - Private
private extension InlineView {
    enum Constants {
        static let stackOffset: CGFloat = 16
    }

    func setupUI() {
        func setupView() {
            backgroundColor = .systemBackground
        }

        func setupScrollView() {
            addSubview(scrollView)

            scrollView.backgroundColor = .systemBackground
            scrollView.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                scrollView.centerXAnchor.constraint(equalTo: centerXAnchor),
                scrollView.widthAnchor.constraint(equalTo: widthAnchor),
                scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            ])
        }

        func setupContentStackView() {
            scrollView.addSubview(contentStackView)

            contentStackView.translatesAutoresizingMaskIntoConstraints = false
            contentStackView.axis = .vertical
            contentStackView.spacing = Constants.stackOffset
            contentStackView.alignment = .center

            let heightConstraint = contentStackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
            heightConstraint.priority = .defaultLow

            NSLayoutConstraint.activate([
                contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                contentStackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
                contentStackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
                heightConstraint
            ])
        }
        
        setupView()
        setupScrollView()
        setupContentStackView()

        hideKeyboardWhenTapped()
    }

    func addSpacingText() {
        let spacingLabel = UILabel()
        spacingLabel.translatesAutoresizingMaskIntoConstraints = false
        spacingLabel.numberOfLines = 0
        spacingLabel.textColor = .label
        spacingLabel.text = Array(
            repeating: "I will not waste chalk  I will not waste chalk",
            count: 60
        ).joined(separator: "\n")

        contentStackView.addArrangedSubview(spacingLabel)
    }

    func addUIKitBanner(
        with inputModel: GAInlineBannerInputModel,
        size: GASize,
        parent: InlineViewController
    ) {
        let banner = GAFactory.createInlineBanner(
            with: inputModel,
            size: size
        )
        banner.delegate = parent
        bannerView = banner

        contentStackView.addArrangedSubview(banner)

        banner.translatesAutoresizingMaskIntoConstraints = false
        banner.loadAd()
    }

    func addSwiftUIBanner(
        with inputModel: GAInlineBannerInputModel,
        size: GASize,
        parent: InlineViewController
    ) {
        addSwiftUIView(
            GAInlineView(
                inputModel: inputModel,
                size: size
            ) { [weak parent] error in
                // Fake banner
                let banner = GAFactory.createInlineBanner(
                    with: inputModel,
                    size: size
                )
                parent?.inlineBannerView(
                    banner,
                    withInputModel: inputModel,
                    didFailLoadingAdWith: error
                )
            },
            to: parent
        ) { swiftuiView in
            bannerView = swiftuiView
            contentStackView.addArrangedSubview(swiftuiView)
            if size == .adaptiveWidth {
                swiftuiView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
            }
        }
    }
}
