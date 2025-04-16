//
//  UIViewController+Alert.swift
//  GreenAdsApp
//
//  Created by GreenAds on 19.09.2023.
//

import UIKit

private var alertQueue: [(String?, String?, (() -> Void)?)] = []

extension UIViewController {
    func showAlert(
        with title: String?,
        message: String? = nil,
        callback: (() -> Void)? = nil
    ) {
        DispatchQueue.main.async {
            guard self.presentedViewController == nil else {
                guard self.presentedViewController is UIAlertController else {
                    return
                }
                return alertQueue.append((title, message, callback))
            }
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

            let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in
                DispatchQueue.main.async {
                    guard !alertQueue.isEmpty else {
                        callback?()
                        return
                    }
                    let alert = alertQueue.removeFirst()
                    self.showAlert(with: alert.0, message: alert.1) {
                        callback?()
                        alert.2?()
                    }
                }
            }

            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
    }
}
