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
	}

	func start() {
		let navVC = UINavigationController()
		navigationController = navVC

		let topHeadlinesCoordinator = TopHeadlinesCoordinator(
			navigationController: navVC, dataProvider: dataProvider)
		childCoordinators.append(topHeadlinesCoordinator)
		topHeadlinesCoordinator.start()

		window.rootViewController = navigationController
		window.makeKeyAndVisible()
	}
}
