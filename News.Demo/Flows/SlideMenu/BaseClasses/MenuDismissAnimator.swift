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
			let navVC = transitionContext.viewController(forKey: .to) as? NewsNavigationController
		else {
				return
		}
		// Solving rotation problem during menu presentation
		// https://stackoverflow.com/questions/31969524
		navVC.view.frame = transitionContext.finalFrame(for: navVC)

		let containerView = transitionContext.containerView
		containerView.addSubview(slideMenuVC.view)

		guard let oldSnapshot = containerView.viewWithTag(MenuHelper.snapshotTag),
			let snapshot = navVC.view.snapshotView(afterScreenUpdates: true) else {
			return
		}

		slideMenuVC.view.frame.size.width = containerView.bounds.width
		slideMenuVC.view.frame.size.height = containerView.bounds.height

		snapshot.isUserInteractionEnabled = false
		snapshot.layer.shadowOpacity = 1
		snapshot.layer.shadowRadius = 20
		snapshot.transform = oldSnapshot.transform
		containerView.insertSubview(snapshot, aboveSubview: slideMenuVC.view)
		oldSnapshot.removeFromSuperview()

		// Animation
		UIView.animate(
			withDuration: transitionDuration(using: transitionContext),
			delay: 0,
			options: .curveEaseOut,
			animations: { snapshot.transform = .identity },
			completion: { _ in
				let didTransitionComplete = !transitionContext.transitionWasCancelled
				if didTransitionComplete {
					snapshot.removeFromSuperview()
					navVC.autorotation = true
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
