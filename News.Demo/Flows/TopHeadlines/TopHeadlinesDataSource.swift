//
//  TopHeadlinesDataSource.swift
//  News.Demo
//
//  Created by Mikhail Kulichkov on 14.01.2020.
//  Copyright © 2020 Kulichkov. All rights reserved.
//

import UIKit

final class TopHeadlinesDataSource: NSObject {
	private(set) var noMoreData: Bool = false
	private let dataProvider: NewsDataProviderProtocol
	private let articleCellID: String
	private let activityViewID: String
	private let refreshingLock = NSLock()
	private var isRefreshable: Bool { !dataProvider.topHeadlines.isEmpty }
	private var isRefreshing: Bool = false

	init(dataProvider: NewsDataProviderProtocol, articleCellID: String, activityViewID: String) {
		self.dataProvider = dataProvider
		self.articleCellID = articleCellID
		self.activityViewID = activityViewID
	}

	func fetch(completion: NewsDataProviderProtocol.Completion?) {
		guard !noMoreData else {
			completion?(.noMoreData)
			return
		}
		print("Fetching new pack of top headlines...")
		dataProvider.fetchMoreTopHeadlines { [weak self] error in
			switch error {
			case .noMoreData:
				self?.noMoreData = true
				fallthrough
			case .some:
				print(error!)
			default:
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
		noMoreData = false
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

	private func setIsRefreshing(_ value: Bool) {
		refreshingLock.lock()
		isRefreshing = value
		refreshingLock.unlock()
	}
}

extension TopHeadlinesDataSource: Collection {
	var startIndex: Int {
		dataProvider.topHeadlines.startIndex
	}

	var endIndex: Int {
		dataProvider.topHeadlines.endIndex
	}

	func index(after i: Int) -> Int {
		i + 1
	}

	subscript(index: Int) -> Article {
		dataProvider.topHeadlines[index]
	}
}

extension TopHeadlinesDataSource: UICollectionViewDataSource {
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

	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		guard kind == UICollectionView.elementKindSectionFooter else { return UICollectionReusableView() }
		return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: activityViewID, for: indexPath)
	}
}
