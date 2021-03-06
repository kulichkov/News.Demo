//
//  AppCoordinator.swift
//  News.Demo
//
//  Created by Mikhail Kulichkov on 07.01.2020.
//  Copyright © 2020 Kulichkov. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {
	var parentCoordinator: Coordinator?
	var childCoordinators = [Coordinator]()
	var navigationController: UINavigationController?
	private let window: UIWindow
	private let repository = NewsRepository()
	private lazy var dataProvider = NewsDataProvider(newsRepository: repository, pageSize: 10)
	private let imageRepository = ImageRepository()

	init(window: UIWindow) {
		self.window = window
		NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: UIContentSizeCategory.didChangeNotification, object: nil)
	}

	func start() {
		let navVC = UINavigationController()
		navigationController = navVC
		window.rootViewController = navigationController
		window.frame = UIScreen.main.bounds
		window.makeKeyAndVisible()

		let topHeadlinesCoordinator = TopHeadlinesCoordinator(
			navigationController: navVC, dataProvider: dataProvider, imageRepository: imageRepository)
		let menuCoordinator = SlideMenuCoordinator(coordinator: topHeadlinesCoordinator)
		childCoordinators.append(menuCoordinator)
		menuCoordinator.parentCoordinator = self
		menuCoordinator.start()
	}

	@objc
	private func handleNotification(_ notification: Notification) {
		if notification.name == UIContentSizeCategory.didChangeNotification {
			refreshChildCoordinators()
		}
	}
}
