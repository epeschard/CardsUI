//
//  CardPresentationController.swift
//  CardsUI
//
//  Created by Eugène Peschard on 24/04/2017.
//

import UIKit

class CardPresentationController: UIPresentationController {
  
  lazy var dimmingView :UIView = {
    let view = UIView(frame: self.containerView!.bounds)
    view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
//    view.alpha = 0.0
    view.layer.cornerRadius = 7
    view.clipsToBounds = true
    return view
  }()
  
  override func presentationTransitionWillBegin() {
    
    guard
      let containerView = containerView,
      let presentedView = presentedView
      else {
        return
    }
    
    // Add the dimming view and the presented view to the heirarchy
    dimmingView.frame = containerView.bounds
    containerView.addSubview(dimmingView)
    containerView.addSubview(presentedView)
    
    // Fade in the dimming view alongside the transition
    if let transitionCoordinator = self.presentingViewController.transitionCoordinator {
      transitionCoordinator.animate(alongsideTransition: {
        (context: UIViewControllerTransitionCoordinatorContext!) -> Void in
        self.dimmingView.alpha = 1.0
      }, completion:nil)
    }
  }
  
  override func presentationTransitionDidEnd(_ completed: Bool)  {
    // If the presentation didn't complete, remove the dimming view
    if !completed {
      self.dimmingView.removeFromSuperview()
    }
  }
  
  override func dismissalTransitionWillBegin()  {
    // Fade out the dimming view alongside the transition
    if let transitionCoordinator = self.presentingViewController.transitionCoordinator {
      transitionCoordinator.animate(alongsideTransition: {(context: UIViewControllerTransitionCoordinatorContext!) -> Void in
        self.dimmingView.alpha  = 0.0
      }, completion:nil)
    }
  }
  
  override func dismissalTransitionDidEnd(_ completed: Bool) {
    // If the dismissal completed, remove the dimming view
    if completed {
      self.dimmingView.removeFromSuperview()
    }
  }
  
  override var frameOfPresentedViewInContainerView : CGRect {
    
    // We don't want the presented view to fill the whole container view, so inset it's frame
    let frame = self.containerView!.bounds;
    var presentedViewFrame = CGRect.zero
    presentedViewFrame.size = CGSize(width: frame.size.width, height: frame.size.height - 40)
    presentedViewFrame.origin = CGPoint(x: 0, y: 40)
    
    return presentedViewFrame
  }
  
  override func viewWillTransition(to size: CGSize, with transitionCoordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: transitionCoordinator)
    
    guard
      let containerView = containerView
      else {
        return
    }
    
    transitionCoordinator.animate(alongsideTransition: {(context: UIViewControllerTransitionCoordinatorContext!) -> Void in
      self.dimmingView.frame = containerView.bounds
    }, completion:nil)
  }
  
}
