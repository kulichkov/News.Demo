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
	private lazy var dataProvider = NewsDataProvider(newsRepository: repository, language: .english, pageSize: 5)

	init(window: UIWindow) {
		self.window = window
	}

	func start() {
		let rootVC = UIViewController()
		rootVC.view.backgroundColor = .blue
		let navVC = UINavigationController(rootViewController: rootVC)
		navigationController = navVC

		dataProvider.setPageSize(10) { [weak self] error in
			if let error = error {
				print(error)
				self?.dataProvider.topHeadlines.map { $0.title ?? "NO TITLE" }.forEach { print($0) }
			} else if let dataProvider = self?.dataProvider {
				print("Now provider have got \(dataProvider.topHeadlines.count) top headlines")
				self?.fetch(dataProvider: dataProvider)
			}
		}

		window.rootViewController = navigationController
		window.makeKeyAndVisible()
	}

	func fetch(dataProvider: NewsDataProviderProtocol) {
		print("Fetching new pack of top headlines...")
		dataProvider.fetchMoreTopHeadlines { [weak self] error in
			if let error = error {
				print(error)
				dataProvider.topHeadlines.map { $0.title ?? "NO TITLE" }.forEach { print($0) }
			} else {
				print("Now provider have got \(dataProvider.topHeadlines.count) top headlines")
				self?.fetch(dataProvider: dataProvider)
			}
		}
	}

}
