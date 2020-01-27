//
//  MenuControlledCoordinator.swift
//  News.Demo
//
//  Created by Mikhail Kulichkov on 26.01.2020.
//  Copyright © 2020 Kulichkov. All rights reserved.
//

import UIKit

class MenuControlledCoordinator: Coordinator {
	var childCoordinators: [Coordinator] = []

	var navigationController: UINavigationController?

	let viewController = MenuControlledViewController()

	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
		viewController.delegate = self
	}

	func start() {
		navigationController?.pushViewController(viewController, animated: false)
	}
}

extension MenuControlledCoordinator: MenuControlledViewControllerDelegate {
	func viewControllerDidPressMenuBarButton(_ viewController: MenuControlledViewController) {
		print("viewControllerDidPressMenuBarButton")
	}
}