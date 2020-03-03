//
//  MenuControlledCoordinator.swift
//  News.Demo
//
//  Created by Mikhail Kulichkov on 26.01.2020.
//  Copyright © 2020 Kulichkov. All rights reserved.
//

import UIKit

protocol MenuControlledCoordinatorDelegate: class {
	func coordinatorDidPressMenuBarButton(_ coordinator: MenuControlledCoordinator)
	func coordinator(_ coordinator: MenuControlledCoordinator, didHandlePanGestureRecognizer panGestureRecognizer: UIPanGestureRecognizer)
}

class MenuControlledCoordinator: NSObject, Coordinator {
	var parentCoordinator: Coordinator?
	var childCoordinators: [Coordinator] = []
	var navigationController: UINavigationController?
	let viewController: MenuControlledViewController
	weak var delegate: MenuControlledCoordinatorDelegate?

	init(navigationController: UINavigationController, viewController: MenuControlledViewController) {
		self.navigationController = navigationController
		self.viewController = viewController
		super.init()
		viewController.delegate = self
	}

	func start() {
		navigationController?.pushViewController(viewController, animated: false)
	}
}

extension MenuControlledCoordinator: MenuControlledViewControllerDelegate {
	func viewControllerDidPressMenuBarButton(_ viewController: MenuControlledViewController) {
		delegate?.coordinatorDidPressMenuBarButton(self)
	}

	func viewController(_ viewController: MenuControlledViewController, didPanGestureWithRecognizer panGestureRecognizer: UIPanGestureRecognizer) {
		delegate?.coordinator(self, didHandlePanGestureRecognizer: panGestureRecognizer)
	}
}
