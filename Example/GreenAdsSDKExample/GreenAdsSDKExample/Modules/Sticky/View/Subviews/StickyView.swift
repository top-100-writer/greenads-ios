//
//  StickyView.swift
//  GreenAdsApp
//
//  Created by GreenAds on 16.12.2024.
//

import UIKit
import GreenAdsSDK
import SwiftUI

final class StickyView: UIView {
    // MARK: Private properties

    private let containerView = UIView()
    private let scrollView = UIScrollView()
    private let textLabel = UILabel()

    private var bannerView: UIView?

    private lazy var textTopConstraint = textLabel.topAnchor.constraint(equalTo: scrollView.topAnchor)
    private lazy var textBottomConstraint = textLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)

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
        _ inputModel: GAStickyBannerInputModel,
        fixed isFixed: Bool,
        uiKit isUIKit: Bool,
        top isTop: Bool,
        parent: StickyViewController
    ) {
        let size: GASize = isFixed ? .fixed : .adaptiveWidth
        if isUIKit {
            showUIKitBanner(
                inputModel,
                size: size,
                top: isTop,
                parent: parent
            )
        } else {
            showSwiftUIBanner(
                inputModel,
                size: size,
                top: isTop,
                parent: parent
            )
        }
        if isTop {
            textTopConstraint.constant = Constants.textInset + Constants.bannerHeight
            textBottomConstraint.constant = -Constants.textInset
        } else {
            textTopConstraint.constant = Constants.textInset
            textBottomConstraint.constant = -Constants.textInset - Constants.bannerHeight
        }
    }
}

// MARK: - Private
private extension StickyView {
    enum Constants {
        static let textInset: CGFloat = 16
        static let bannerHeight: CGFloat = 50
    }

    func setupUI() {
        func setupView() {
            backgroundColor = .systemBackground
        }

        func setupContainerView() {
            addSubview(containerView)

            containerView.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                containerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                containerView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
                containerView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor),
                containerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
            ])
        }

        func setupScrollView() {
            containerView.addSubview(scrollView)

            scrollView.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                scrollView.topAnchor.constraint(equalTo: containerView.topAnchor),
                scrollView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
                scrollView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
                scrollView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
        }

        func setupTextLabel() {
            scrollView.addSubview(textLabel)

            textLabel.translatesAutoresizingMaskIntoConstraints = false
            textLabel.font = .systemFont(ofSize: 16)
            textLabel.textColor = .label
            textLabel.numberOfLines = 0
            textLabel.text = String(
                repeating: "I will not waste chalk  I will not waste chalk\n",
                count: 60
            )

            NSLayoutConstraint.activate([
                textLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
                textLabel.leftAnchor.constraint(greaterThanOrEqualTo: scrollView.leftAnchor, constant: Constants.textInset),
                textTopConstraint,
                textBottomConstraint
            ])
        }

        setupView()
        setupContainerView()
        setupScrollView()
        setupTextLabel()
    }

    func showUIKitBanner(
        _ inputModel: GAStickyBannerInputModel,
        size: GASize,
        top isTop: Bool,
        parent: StickyViewController
    ) {
        let banner = GAFactory.createStickyBanner(with: inputModel, size: size)
        bannerView = banner
        if isTop {
            banner.displayAtTop(in: containerView)
        } else {
            banner.displayAtBottom(in: containerView)
        }
        banner.delegate = parent
        banner.loadAd()
    }

    func showSwiftUIBanner(
        _ inputModel: GAStickyBannerInputModel,
        size: GASize,
        top isTop: Bool,
        parent: StickyViewController
    ) {
        addSwiftUIView(
            GAStickyView(
                inputModel: inputModel,
                size: size
            ) { [weak parent, weak bannerView] error in
                // Fake banner
                let banner = GAFactory.createStickyBanner(
                    with: inputModel,
                    size: size
                )
                parent?.stickyBannerView(
                    banner,
                    withInputModel: inputModel,
                    didFailLoadingAdWith: error
                )
                bannerView?.removeFromSuperview()
            },
            to: parent
        ) { swiftuiView in
            bannerView = swiftuiView
            containerView.addSubview(swiftuiView)
            let keyPath: KeyPath<UIView, NSLayoutYAxisAnchor> = isTop ? \.topAnchor : \.bottomAnchor
            NSLayoutConstraint.activate([
                swiftuiView[keyPath: keyPath].constraint(equalTo: containerView[keyPath: keyPath]),
                swiftuiView.centerXAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.centerXAnchor),
                swiftuiView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            ])
        }
    }
}
