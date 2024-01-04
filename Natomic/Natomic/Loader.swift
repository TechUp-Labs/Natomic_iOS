//
//  Loader.swift
//  Natomic
//
//  Created by Archit Navadiya on 26/12/23.
//

import UIKit
import NVActivityIndicatorView

class Loader {
    static let shared = Loader()

    private var activityIndicator: NVActivityIndicatorView!
    private var overlayView: UIView!

    private init() {
        // Initialize the activity indicator
        activityIndicator = NVActivityIndicatorView(
            frame: CGRect(x: 0, y: 0, width: 40, height: 40),
            type: .ballClipRotate,
            color: .black,
            padding: nil
        )

        // Initialize the overlay view
        overlayView = UIView()
        overlayView.backgroundColor = UIColor.lightGray
        overlayView.alpha = 0.5
    }

    func startAnimating(in view: UIView) {
        // Add the overlay view and activity indicator to the given view
        overlayView.frame = view.bounds
        view.addSubview(overlayView)

        activityIndicator.center = view.center
        view.addSubview(activityIndicator)

        // Start animating
        activityIndicator.startAnimating()
    }

    func stopAnimating() {
        // Stop animating and remove the overlay view and activity indicator
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
        overlayView.removeFromSuperview()
    }

    func startAnimating() {
        // Start animating on the window
        if let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            startAnimating(in: keyWindow)
        }
    }
}
