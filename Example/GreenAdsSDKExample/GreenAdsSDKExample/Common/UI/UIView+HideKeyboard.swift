//
//  UIView+HideKeyboard.swift
//  GreenAdsApp
//
//  Created by GreenAds on 01.02.2025.
//

import UIKit

extension UIView {
    func hideKeyboardWhenTapped() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIView.dismissKeyboard))
        tap.cancelsTouchesInView = false
        addGestureRecognizer(tap)
    }

    @objc
    private func dismissKeyboard() {
        endEditing(true)
    }
}
