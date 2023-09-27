//
//  ViewController.swift
//  Natomic
//
//  Created by Archit's Mac on 23/06/23.
//

import UIKit

class SplashVC: UIViewController {
    
    // MARK: - Outlet's :-
    
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var logoWidth: NSLayoutConstraint!
    @IBOutlet weak var logoHeight: NSLayoutConstraint!
    
    // MARK: - Variable's :-
    
    
    // MARK: - ViewController Life Cycle:-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if IS_STARTED {
            self.navigationController?.pushViewController(HOME_VC, animated: true)
        }else{
            self.navigationController?.pushViewController(WELCOME_VC, animated: true)
        }
        
        
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
        //            self.increaseLogoSize()
        //            self.startRotationAnimation()
        //        }
        
    }
    
    // MARK: - All Fuction's : -
    
    func startRotationAnimation() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = NSNumber(value: Double.pi * 1.5) // 360 degrees
        rotationAnimation.duration = 1.0 // Duration of the rotation animation (in seconds)
        rotationAnimation.repeatCount = 1 // Repeat indefinitely
        imgLogo.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    func increaseLogoSize() {
        UIView.animate(withDuration: 1.0) {
            self.logoWidth.constant = 154
            self.logoHeight.constant = 154
            self.view.layoutIfNeeded()
        }completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.navigationController!.pushViewController(HOME_VC, animated: false)
            }
        }
    }
    
    
}

