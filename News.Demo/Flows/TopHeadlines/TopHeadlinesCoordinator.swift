//
//  TopHeadlinesCoordinator.swift
//  News.Demo
//
//  Created by Mikhail Kulichkov on 13.01.2020.
//  Copyright © 2020 Kulichkov. All rights reserved.
//

import UIKit

class TopHeadlinesCoordinator: MenuControlledCoordinator {
	private let topHeadlinesVC: TopHeadlinesViewController
	private let dataProvider: NewsDataProviderProtocol

	init(navigationController: UINavigationController, dataProvider: NewsDataProviderProtocol, imageRepository: ImageRepositoryProtocol) {
		self.dataProvider = dataProvider
		self.topHeadlinesVC = TopHeadlinesViewController(dataProvider: dataProvider, imageRepository: imageRepository)
		super.init(navigationController: navigationController, viewController: topHeadlinesVC)
	}
}

extension TopHeadlinesCoordinator: Refreshable {
	func refresh() {
		topHeadlinesVC.refreshAppearance()
		refreshChildCoordinators()
	}
}

protocol Reloadable: class {
	func reload()
}

extension TopHeadlinesCoordinator: Reloadable {
	func reload() {
		topHeadlinesVC.reload()
	}
}
