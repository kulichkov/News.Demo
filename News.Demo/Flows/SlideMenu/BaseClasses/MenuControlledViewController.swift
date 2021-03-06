//
//  MenuControlledViewController.swift
//  News.Demo
//
//  Created by Mikhail Kulichkov on 26.01.2020.
//  Copyright © 2020 Kulichkov. All rights reserved.
//

import UIKit

protocol MenuControlledViewControllerDelegate: class {
	func viewControllerDidPressMenuBarButton(_ viewController: MenuControlledViewController)
	func viewController(_ viewController: MenuControlledViewController, didPanGestureWithRecognizer panGestureRecognizer: UIPanGestureRecognizer)
}

class MenuControlledViewController: UIViewController, Coordinated {
	weak var coordinator: Coordinator?
	weak var delegate: MenuControlledViewControllerDelegate?

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Menu Controlled"
		navigationItem.leftBarButtonItem = UIBarButtonItem(
			image: #imageLiteral(resourceName: "menu_icon"), style: .plain, target: self, action: #selector(menuBarButtonPressed))
		let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
		view.addGestureRecognizer(panGestureRecognizer)
	}

	@objc
	private func menuBarButtonPressed(_ sender: UIBarButtonItem) {
		delegate?.viewControllerDidPressMenuBarButton(self)
	}

	@objc
	private func handlePanGesture(sender: UIPanGestureRecognizer) {
		delegate?.viewController(self, didPanGestureWithRecognizer: sender)
	}
}
