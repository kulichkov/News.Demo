//
//  MenuDismissAnimator.swift
//  News.Demo
//
//  Created by Mikhail Kulichkov on 29.01.2020.
//  Copyright © 2020 Kulichkov. All rights reserved.
//

import UIKit

class MenuDismissAnimator: NSObject {}

extension MenuDismissAnimator: UIViewControllerAnimatedTransitioning {
	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		0.3
	}

	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		guard let slideMenuVC = transitionContext.viewController(forKey: .from) as? SlideMenuViewController,
			let toVC = transitionContext.viewController(forKey: .to)
		else {
				return
		}

		let containerView = transitionContext.containerView
		containerView.addSubview(slideMenuVC.view)

		slideMenuVC.view.frame.size.width = containerView.bounds.width
		slideMenuVC.view.frame.size.height = containerView.bounds.height
/*
		guard let snapshot = toVC.view.snapshotView(afterScreenUpdates: true) else {
			return
		}
//		snapshot?.tag = MenuHelper.snapshotTag
//		snapshot?.isUserInteractionEnabled = false
//		snapshot?.layer.shadowOpacity = 1
//		snapshot?.layer.shadowRadius = 20

//		if let snapshot = snapshot {
//			containerView.insertSubview(snapshot, belowSubview: slideMenuVC.dismissButton)
//		}
	
		slideMenuVC.slidingView.subviews.first?.removeFromSuperview()
		slideMenuVC.slidingView.addSubview(snapshot)

//		fromVC.view.isHidden = true

		// Animation
		UIView.animate(
			withDuration: transitionDuration(using: transitionContext),
			delay: 0,
			options: .curveEaseOut,
			animations: { slideMenuVC.slidingViewLeading.constant = 0
				slideMenuVC.slidingView.transform = .identity },
			completion: { _ in
				let didTransitionComplete = !transitionContext.transitionWasCancelled
				if didTransitionComplete {
					//containerView.insertSubview(toVC.view, aboveSubview: slideMenuVC.view)
					snapshot.removeFromSuperview()
				}
				transitionContext.completeTransition(didTransitionComplete) })
*/
/*
		// Menu items animation
		for menuItem in slideMenuVC.btnMenuItems {
			menuItem.alpha = 0.0
			menuItem.transform = CGAffineTransform(translationX: 0, y: 150)
		}
		UIView.animateKeyframes(withDuration: transitionDuration(using: transitionContext) + 0.5,
								delay: 0,
								options: [],
								animations: {
									for (index, menuItem) in slideMenuVC.btnMenuItems.enumerated() {
										UIView.addKeyframe(withRelativeStartTime: Double(index) * (0.5 / Double(slideMenuVC.btnMenuItems.count)),
														   relativeDuration: 0.5,
														   animations: { menuItem.alpha = 1
															menuItem.transform = .identity })
									} },
								completion: nil)

		// News back animation
		slideMenuVC.lblNewsBack.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
		UIView.animate(withDuration: transitionDuration(using: transitionContext) + 1,
					   animations: { slideMenuVC.lblNewsBack.transform = .identity })
*/
	}
}
