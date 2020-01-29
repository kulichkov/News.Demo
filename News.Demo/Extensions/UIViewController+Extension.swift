//
//  UIViewController+Extension.swift
//  News.Demo
//
//  Created by Mikhail Kulichkov on 28.01.2020.
//  Copyright © 2020 Kulichkov. All rights reserved.
//

import UIKit

extension UIViewController {
	func add(_ childViewController: UIViewController, toContainer container: UIView) {
		// Add child view controller
		addChild(childViewController)

		// Add child view as subview
		container.addSubview(childViewController.view)

		// Configure child view
		container.translatesAutoresizingMaskIntoConstraints = false
		childViewController.view.translatesAutoresizingMaskIntoConstraints = false
		childViewController.view.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
		childViewController.view.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
		childViewController.view.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
		childViewController.view.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true

		// Notify child view controller
		childViewController.didMove(toParent: self)
	}

	func remove(asChildViewController childViewController: UIViewController) {
		// Notify child view controller
		childViewController.willMove(toParent: nil)

		// Remove child view from superview
		childViewController.view.removeFromSuperview()

		// Notify child view controller
		childViewController.removeFromParent()
	}
}
