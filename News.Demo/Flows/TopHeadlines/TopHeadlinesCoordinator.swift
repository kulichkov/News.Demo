//
//  TopHeadlinesCoordinator.swift
//  News.Demo
//
//  Created by Mikhail Kulichkov on 13.01.2020.
//  Copyright © 2020 Kulichkov. All rights reserved.
//

import UIKit

class TopHeadlinesCoordinator: Coordinator {
	var childCoordinators: [Coordinator] = []
	var navigationController: UINavigationController?

	private lazy var topHeadlinesVC = TopHeadlinesViewController(dataProvider: dataProvider)
	private let dataProvider: NewsDataProviderProtocol

	init(navigationController: UINavigationController, dataProvider: NewsDataProviderProtocol) {
		self.navigationController = navigationController
		self.dataProvider = dataProvider
	}

	func start() {
		navigationController?.pushViewController(topHeadlinesVC, animated: false)
	}
}

extension TopHeadlinesCoordinator: Refreshable {
	func refresh() {
		topHeadlinesVC.refreshAppearance()
		refreshChildCoordinators()
	}
}
