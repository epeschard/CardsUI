//
//  CardAnimationController.swift
//  CardsUI
//
//  Created by Eugène Peschard on 24/04/2017.
//

import UIKit


class CardAnimationController: NSObject {
  
  let isPresenting :Bool
  let duration :TimeInterval = 0.5
  
  init(isPresenting: Bool) {
    self.isPresenting = isPresenting
    
    super.init()
  }
}

// MARK: - UIViewControllerAnimatedTransitioning

extension CardAnimationController: UIViewControllerAnimatedTransitioning {
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return self.duration
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning)  {
    let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
    let fromView = fromVC?.view
    let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
    let toView = toVC?.view
    
    let containerView = transitionContext.containerView
    
    if isPresenting {
      containerView.addSubview(toView!)
    }
    
    let bottomVC = isPresenting ? fromVC : toVC
    let bottomPresentingView = bottomVC?.view
    
    let topVC = isPresenting ? toVC : fromVC
    let topPresentedView = topVC?.view
    var topPresentedFrame = transitionContext.finalFrame(for: topVC!)
    let topDismissedFrame = topPresentedFrame
    topPresentedFrame.origin.y -= topDismissedFrame.size.height
    let topInitialFrame = topDismissedFrame
    let topFinalFrame = isPresenting ? topPresentedFrame : topDismissedFrame
    topPresentedView?.frame = topInitialFrame
    
    UIView.animate(withDuration: self.transitionDuration(using: transitionContext),
                   delay: 0,
                   usingSpringWithDamping: 300.0,
                   initialSpringVelocity: 5.0,
                   options: [.allowUserInteraction, .beginFromCurrentState], //[.Alert, .Badge]
      animations: {
        topPresentedView?.frame = topFinalFrame
        let scalingFactor : CGFloat = self.isPresenting ? 0.92 : 1.0
        bottomPresentingView?.transform = CGAffineTransform.identity.scaledBy(x: scalingFactor, y: scalingFactor)
        bottomPresentingView?.layer.cornerRadius = 5
        bottomPresentingView?.clipsToBounds = true
        
    }, completion: {
      (value: Bool) in
      if !self.isPresenting {
        fromView?.removeFromSuperview()
      }
    })
    
    
    if isPresenting {
      animatePresentationWithTransitionContext(transitionContext)
    }
    else {
      animateDismissalWithTransitionContext(transitionContext)
    }
  }
  
  func animatePresentationWithTransitionContext(_ transitionContext: UIViewControllerContextTransitioning) {
    
    let containerView = transitionContext.containerView
    guard
      let presentedController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
      let presentedControllerView = transitionContext.view(forKey: UITransitionContextViewKey.to)
      else {
        return
    }
    
    // Position the presented view off the top of the container view
    presentedControllerView.frame = transitionContext.finalFrame(for: presentedController)
    presentedControllerView.center.y += containerView.bounds.size.height
    
    containerView.addSubview(presentedControllerView)
    
    // Animate the presented view to it's final position
    UIView.animate(withDuration: self.duration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .allowUserInteraction, animations: {
      presentedControllerView.center.y -= containerView.bounds.size.height
    }, completion: {(completed: Bool) -> Void in
      transitionContext.completeTransition(completed)
    })
  }
  
  func animateDismissalWithTransitionContext(_ transitionContext: UIViewControllerContextTransitioning) {
    
    let containerView = transitionContext.containerView
    
    guard
      let presentedControllerView = transitionContext.view(forKey: UITransitionContextViewKey.from)
      else {
        return
    }
    
    // Animate the presented view off the bottom of the view
    UIView.animate(withDuration: self.duration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .allowUserInteraction, animations: {
      presentedControllerView.center.y += containerView.bounds.size.height
    }, completion: {(completed: Bool) -> Void in
      transitionContext.completeTransition(completed)
    })
  }
}
