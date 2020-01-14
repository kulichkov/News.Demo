//
//  TopHeadlinesDataSource.swift
//  News.Demo
//
//  Created by Mikhail Kulichkov on 14.01.2020.
//  Copyright © 2020 Kulichkov. All rights reserved.
//

import UIKit

final class TopHeadlinesDataSource: NSObject, UICollectionViewDataSource {
	private let dataProvider: NewsDataProviderProtocol
	private let articleCellID: String

	init(dataProvider: NewsDataProviderProtocol, articleCellReuseID: String) {
		self.dataProvider = dataProvider
		self.articleCellID = articleCellReuseID
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return dataProvider.topHeadlines.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: articleCellID, for: indexPath) as? ArticleCollectionViewCell else {
			return UICollectionViewCell()
		}
		let article = dataProvider.topHeadlines[indexPath.item]
		cell.fill(article: article)
		return cell
	}

	func fetch(completion: NewsDataProviderProtocol.Completion?) {
		print("Fetching new pack of top headlines...")
		dataProvider.fetchMoreTopHeadlines { [weak self] error in
			if let error = error {
				print(error)
				DispatchQueue.main.async { completion?(error) }
			} else {
				print("Now provider have got \(self?.dataProvider.topHeadlines.count ?? 0) top headlines")
				self?.fetch(completion: completion)
			}
		}
	}

	subscript(index: Int) -> Article {
		dataProvider.topHeadlines[index]
	}
}
