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
		guard let fromVC = transitionContext.viewController(forKey: .from),
			let slideMenuVC = transitionContext.viewController(forKey: .to) as? SlideMenuViewController else {
				return
		}

		let containerView = transitionContext.containerView
		containerView.insertSubview(slideMenuVC.view, belowSubview: fromVC.view)

		slideMenuVC.view.frame.size.width = containerView.bounds.width
		slideMenuVC.view.frame.size.height = containerView.bounds.height

		let snapshot = fromVC.view.snapshotView(afterScreenUpdates: true)
		snapshot?.tag = MenuHelper.snapshotTag
		snapshot?.isUserInteractionEnabled = false
		snapshot?.layer.shadowOpacity = 1
		snapshot?.layer.shadowRadius = 20

		if let snapshot = snapshot {
			containerView.insertSubview(snapshot, belowSubview: slideMenuVC.dismissButton)
		}

		fromVC.view.isHidden = true

		// Animation
		UIView.animate(
			withDuration: transitionDuration(using: transitionContext),
			delay: 0,
			options: .curveEaseOut,
			animations: { snapshot?.center.x += UIScreen.main.bounds.width * MenuHelper.menuWidthRatio
				snapshot?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9) },
			completion: { _ in
				fromVC.view.isHidden = false
				transitionContext.completeTransition(!transitionContext.transitionWasCancelled) })
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
