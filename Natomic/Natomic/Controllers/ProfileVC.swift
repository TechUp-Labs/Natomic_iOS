//
//  ProfileVC.swift
//  Natomic
//
//  Created by Archit's Mac on 19/07/23.
//

import UIKit

class ProfileVC: UIViewController {
    
    let testView : TestView = .fromNib()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tap(_ sender: Any) {
        // Add the transparent overlay view
        let overlayView = UIView(frame: self.view.bounds)
        overlayView.backgroundColor = UIColor.clear
        self.view.addSubview(overlayView)

        // Add tap gesture recognizer to the overlay view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        overlayView.addGestureRecognizer(tapGesture)

        
        let trailing = (self.view.frame.width - testView.frame.width - 8)
        let topSafeAreaHeight = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0.0
        let bottomSafeAreaHeight = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0.0
        print(topSafeAreaHeight, bottomSafeAreaHeight)
        testView.frame = CGRect(x: trailing, y: topSafeAreaHeight+55, width: testView.frame.width, height: testView.frame.height)
        self.view.addSubview(testView)
        // Show the testView with animation
        testView.alpha = 0.0 // Set the initial alpha to 0 (completely transparent)

        UIView.animate(withDuration: 0.3) {
            self.testView.alpha = 1.0 // Set the final alpha to 1 (fully visible)
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        // Remove the testView when the user taps on the overlay view
        testView.removeFromSuperview()
        sender.view?.removeFromSuperview()
        
    }


    
}

