//
//  AppCoordinator.swift
//  News.Demo
//
//  Created by Mikhail Kulichkov on 07.01.2020.
//  Copyright © 2020 Kulichkov. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {
	var childCoordinators = [Coordinator]()
	var navigationController: UINavigationController?
	private let window: UIWindow
	private let repository = NewsRepository()
	private lazy var dataProvider = NewsDataProvider(newsRepository: repository, language: .russian, pageSize: 10)

	init(window: UIWindow) {
		self.window = window
		NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: UIContentSizeCategory.didChangeNotification, object: nil)
	}

	func start() {
		let navVC = NewsNavigationController()
		navigationController = navVC
		window.rootViewController = navigationController
		window.makeKeyAndVisible()

		//		let topHeadlinesCoordinator = TopHeadlinesCoordinator(
		//			navigationController: navVC, dataProvider: dataProvider)

		let greenVC = MenuControlledViewController()
		greenVC.view.backgroundColor = .green
		let menuControlledCoordinator = MenuControlledCoordinator(
			navigationController: navVC, viewController: greenVC)
		let menuCoordinator = SlideMenuCoordinator(coordinator: menuControlledCoordinator)
		childCoordinators.append(menuCoordinator)
		menuCoordinator.start()
	}

	@objc
	private func handleNotification(_ notification: Notification) {
		if notification.name == UIContentSizeCategory.didChangeNotification {
			refreshChildCoordinators()
		}
	}
}
