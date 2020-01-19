//
//  SlideMenuCoordinator.swift
//  News.Demo
//
//  Created by Mikhail Kulichkov on 17.01.2020.
//  Copyright © 2020 Kulichkov. All rights reserved.
//

import UIKit

class SlideMenuCoordinator: Coordinator {

	var childCoordinators: [Coordinator] = []
	var navigationController: UINavigationController?
	lazy var menuVC = UIViewController()

	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}

	func start() {
		menuVC.view.backgroundColor = .blue
		navigationController?.present(menuVC, animated: false, completion: nil)
	}

}
