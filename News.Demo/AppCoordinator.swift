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
	private lazy var dataProvider = NewsDataProvider(newsRepository: repository)

	init(window: UIWindow) {
		self.window = window
	}

	func start() {
		let rootVC = UIViewController()
		rootVC.view.backgroundColor = .blue
		let navVC = UINavigationController(rootViewController: rootVC)
		navigationController = navVC

		dataProvider.fetchTopHeadlines(language: .russian, completion: nil)

		window.rootViewController = navigationController
		window.makeKeyAndVisible()
	}
}
