//
//  SpringAnimator.swift
//  Natomic
//
//  Created by Archit's Mac on 02/08/23.
//

import Foundation
import UIKit

class SpringAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration: TimeInterval
    let dampingRatio: CGFloat
    let initialVelocity: CGFloat
    
    init(duration: TimeInterval, dampingRatio: CGFloat, initialVelocity: CGFloat) {
        self.duration = duration
        self.dampingRatio = dampingRatio
        self.initialVelocity = initialVelocity
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        guard let fromView = transitionContext.view(forKey: .from),
              let toView = transitionContext.view(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }
        
        containerView.addSubview(toView)
        
        let options: UIView.AnimationOptions = .curveEaseInOut
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: dampingRatio,
                       initialSpringVelocity: initialVelocity,
                       options: options,
                       animations: {
                           fromView.alpha = 0
                           toView.alpha = 1
                       }) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
