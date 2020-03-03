//
//  FullArticleCoordinator.swift
//  News.Demo
//
//  Created by Mikhail Kulichkov on 02.03.2020.
//  Copyright © 2020 Kulichkov. All rights reserved.
//

import UIKit

class FullArticleCoordinator: Coordinator {
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
		navigationController?.pushViewController(fullArticleVC, animated: true)
	}
}

extension FullArticleCoordinator: SharingDelegate {
	func controller(_ controller: UIViewController, didShare article: Article) {
		var activityItems: [Any] = []
		if let url = article.url {
			activityItems = [url as Any]
		} else {
			print("No url to share, sharing title and description...")
			activityItems = [
				article.title ?? "",
				article.description ?? ""
			]
		}
		let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
		navigationController?.present(activityVC, animated: true, completion: nil)
	}
}
