//
//  FullArticleCoordinator.swift
//  News.Demo
//
//  Created by Mikhail Kulichkov on 02.03.2020.
//  Copyright © 2020 Kulichkov. All rights reserved.
//

import UIKit

class FullArticleCoordinator: Coordinator {
	var parentCoordinator: Coordinator?
	var childCoordinators: [Coordinator] = []
	var navigationController: UINavigationController?

	private let article: Article

	init(navigationController: UINavigationController?, article: Article) {
		self.navigationController = navigationController
		self.article = article
	}

	func start() {
		let fullArticleVC = FullArticleViewController(with: article)
		fullArticleVC.sharingDelegate = self
		fullArticleVC.coordinator = self
		navigationController?.pushViewController(fullArticleVC, animated: true)
	}
}

extension FullArticleCoordinator: SharingDelegate {}
