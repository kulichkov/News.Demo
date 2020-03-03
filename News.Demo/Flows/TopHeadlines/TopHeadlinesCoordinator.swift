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
		topHeadlinesVC.coordinator = self
		topHeadlinesVC.newsListDelegate = self
		navigationController.delegate = self
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

extension TopHeadlinesCoordinator: NewsListDelegate {
	func controller(_ controller: UIViewController, didSelectArticle article: Article) {
		let fullArticleCoordinator = FullArticleCoordinator(
			navigationController: navigationController,
			article: article)
		fullArticleCoordinator.parentCoordinator = self
		childCoordinators.append(fullArticleCoordinator)
		fullArticleCoordinator.start()
	}
}

// https://www.hackingwithswift.com/articles/175/advanced-coordinator-pattern-tutorial-ios
extension TopHeadlinesCoordinator: UINavigationControllerDelegate {
	func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
		// Read the view controller we’re moving from.
		guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
			return
		}

		// Check whether our view controller array already contains that view controller. If it does it means we’re pushing a different view controller on top rather than popping it, so exit.
		if navigationController.viewControllers.contains(fromViewController) {
			return
		}

		// We’re still here – it means we’re popping the view controller, so we can check whether it’s a buy view controller
		if let coordinated = fromViewController as? Coordinated {
			childCoordinatorDidFinish(coordinated.coordinator)
		}
	}
}
