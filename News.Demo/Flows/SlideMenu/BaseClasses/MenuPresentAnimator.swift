//
//  MenuPresentAnimator.swift
//  News.Demo
//
//  Created by Mikhail Kulichkov on 27.01.2020.
//  Copyright © 2020 Kulichkov. All rights reserved.
//

import UIKit

class MenuPresentAnimator: NSObject {}

extension MenuPresentAnimator: UIViewControllerAnimatedTransitioning {
	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		0.4
	}

	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		let snapshotScale: CGFloat = 0.9

		guard let navVC = transitionContext.viewController(forKey: .from) as? UINavigationController,
			let slideMenuVC = transitionContext.viewController(forKey: .to) as? SlideMenuViewController else {
				return
		}
//		guard let snapshot = navVC.view.snapshotView(afterScreenUpdates: true) else {
//			return
//		}
//		snapshot.isUserInteractionEnabled = false
//		snapshot.layer.shadowOpacity = 1
//		snapshot.layer.shadowRadius = 20
//		snapshot.tag = MenuHelper.snapshotTag

		let containerView = transitionContext.containerView
		containerView.insertSubview(slideMenuVC.view, belowSubview: navVC.view)
		guard let snapshot = slideMenuVC.makeOrUpdateSnapshot(animated: false) else {
			return
		}

		let startTranslationX = -slideMenuVC.dismissButton.frame.origin.x
			//- 0.5 * snapshot.bounds.width * (1 - snapshotScale)
		slideMenuVC.dismissButton.transform = CGAffineTransform(translationX: startTranslationX, y: 0)

		navVC.view.isHidden = true

		// Animation
		UIView.animate(
			withDuration: transitionDuration(using: transitionContext),
			delay: 0,
			options: .curveEaseOut,
			animations: { slideMenuVC.dismissButton.transform = .identity },
			completion: { _ in
				navVC.view.isHidden = false
				let didTransitionComplete = !transitionContext.transitionWasCancelled
				if !didTransitionComplete {
					slideMenuVC.dismissButton.transform = .identity
					snapshot.removeFromSuperview()
				}
			 	transitionContext.completeTransition(didTransitionComplete) })
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
