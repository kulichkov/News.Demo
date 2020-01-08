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

	init(window: UIWindow) {
		self.window = window
	}

	func start() {
		let vc = UIViewController()
		vc.view.backgroundColor = .blue
		let navVC = UINavigationController(rootViewController: vc)
		navigationController = navVC

		repository.getTopHeadlines(language: "ru") { result in
			switch result {
			case .success(let data):
				print(String(data: data, encoding: .utf8))
			case .failure(let error):
				print(error)
			}
		}

		window.rootViewController = navigationController
		window.makeKeyAndVisible()
	}
}

