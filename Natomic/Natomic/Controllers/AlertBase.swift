//
//  AlertBase.swift
//  Natomic
//
//  Created by Archit's Mac on 02/08/23.
//

import UIKit

class AlertBase: UIViewController {
    
    var viewBackground:UIView!

    //MARK: - LIFECYCLE
    deinit {
        print("----------------")
        print("DEINIT: \(self)")
        print("----------------")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentViews()
    }
    
    //MARK: - CONFIGURE VIEWS
    private func configureViews(){
        
        self.view.alpha = 0
        
        viewBackground = UIView.init(frame: self.view.frame)
        viewBackground.backgroundColor = .black
        viewBackground.alpha = 0
        
        self.view.addSubview(viewBackground)
        self.view.sendSubviewToBack(viewBackground)
        
        
    }
    private func presentViews(){
        
        var finalContainerFrame = self.view.frame;
        let centerInSelf = self.view.center
        
        finalContainerFrame.origin.x = (centerInSelf.x - finalContainerFrame.width/2.0);
        finalContainerFrame.origin.y = (centerInSelf.y - finalContainerFrame.height/2.0);
        
        // set frame before transform here...
        let startFrame: CGRect = finalContainerFrame
        
        self.view.frame = startFrame
        self.view.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 15.0, options: [], animations: {() -> Void in
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform.identity
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.viewBackground.alpha = 0.5
                })
                
            })
            
        }, completion:{(true) in
            
        })
    }
    
    func dismiss(completion:(() -> Void)? = nil){
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {() -> Void in
            self.view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            if self.viewBackground != nil {
                self.viewBackground.alpha = 0
            }
        }, completion: {(_ finished: Bool) -> Void in
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {() -> Void in
                self.view.alpha = 0.0
                self.view.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            }, completion:{(true) in
                self.view.removeFromSuperview()
                self.dismiss(animated: false, completion: {
                    completion?()
                })
            })
        })
    }

}
