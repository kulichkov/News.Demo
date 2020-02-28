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
		guard let slideMenuVC = transitionContext.viewController(forKey: .from) as? SlideMenuViewController
		else {
			return
		}

		guard let snapshot = slideMenuVC.makeOrUpdateSnapshot(animated: false) else {
			return
		}

		let startTranslationX = -slideMenuVC.dismissButton.frame.origin.x

		// Animation
		UIView.animate(
			withDuration: transitionDuration(using: transitionContext),
			delay: 0,
			options: .curveEaseOut,
			animations: { snapshot.transform = .identity
				slideMenuVC.dismissButton.transform = CGAffineTransform(
					translationX: startTranslationX, y: 0) },
			completion: { _ in
				let didTransitionComplete = !transitionContext.transitionWasCancelled
				if didTransitionComplete {
					snapshot.removeFromSuperview()
				}
				transitionContext.completeTransition(didTransitionComplete) })

/* For advances feature: menu items animation
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
