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
	private let refreshingLock = NSLock()
	private var isRefreshable: Bool { !dataProvider.topHeadlines.isEmpty }
	private var isRefreshing: Bool = false

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
			} else {
				print("Now provider have got \(self?.dataProvider.topHeadlines.count ?? 0) top headlines")
			}
			DispatchQueue.main.async { completion?(error) }
		}
	}

	func refresh(completion: NewsDataProviderProtocol.Completion?) {
		guard isRefreshable && !isRefreshing else {
			completion?(.fetchingInProgress)
			return
		}

		setIsRefreshing(true)
		print("Refreshing top headlines...")
		dataProvider.fetchFreshTopHeadlines { [weak self] error in
			self?.setIsRefreshing(false)
			if let error = error {
				DispatchQueue.main.async { completion?(error) }
			} else {
				print("Now provider have got fresh \(self?.dataProvider.topHeadlines.count ?? 0) top headlines")
				print("Heading to fetch next pages...")
				self?.fetch(completion: completion)
			}
		}
	}

	subscript(index: Int) -> Article {
		dataProvider.topHeadlines[index]
	}

	private func setIsRefreshing(_ value: Bool) {
		refreshingLock.lock()
		isRefreshing = value
		refreshingLock.unlock()
	}
}
