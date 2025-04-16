//
//  UIView+UIHostingController.swift
//  GreenAdsApp
//
//  Created by GreenAds on 25.02.2025.
//

import UIKit
import SwiftUI

extension UIView {
    func addSwiftUIView(_ view: some View, to parent: UIViewController, applying: (UIView) -> Void) {
        let vc = UIHostingController(rootView: view)

        guard let swiftuiView = vc.view else {
            return assertionFailure()
        }
        swiftuiView.translatesAutoresizingMaskIntoConstraints = false

        // 2
        // Add the view controller to the destination view controller.
        parent.addChild(vc)

        // 3
        // Create and activate the constraints for the swiftui's view.
        applying(swiftuiView)

        // 4
        // Notify the child view controller that the move is complete.
        vc.didMove(toParent: parent)
    }
}
