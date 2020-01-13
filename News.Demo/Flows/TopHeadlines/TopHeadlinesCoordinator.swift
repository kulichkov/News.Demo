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

	//private let newsDataProvider: NewsDataProviderProtocol
	private lazy var topHeadlinesVC = TopHeadlinesViewController()

	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}

	func start() {
		navigationController?.pushViewController(topHeadlinesVC, animated: false)
	}

}
