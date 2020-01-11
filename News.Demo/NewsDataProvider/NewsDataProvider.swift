//
//  NewsDataProvider.swift
//  News.Demo
//
//  Created by Mikhail Kulichkov on 09.01.2020.
//  Copyright © 2020 Kulichkov. All rights reserved.
//

import Foundation

final class NewsDataProvider: NewsDataProviderProtocol {
	var topHeadlines: [Article] = []

	private let category: NewsCategory?
	private let language: Language?
	private let country: Country?
	private let sources: [Source]?
	private let q: String?
	private let pageSize: Int

	private var nextPage: Int {
		pageSize > 0 ? (topHeadlines.count / pageSize) + 1 : 1
	}

	private let isFetchingLock = NSLock()
	private var isFetching: Bool = false
	private var topHeadlinesFetchingTask: URLSessionTask?
	private let newsRepository: NewsRepositoryProtocol

	init(newsRepository: NewsRepositoryProtocol, category: NewsCategory? = nil, language: Language? = nil, country: Country? = nil, sources: [Source]? = nil, q: String? = nil, pageSize: Int = 20) {
		self.newsRepository = newsRepository

		self.category = category
		self.language = language
		self.country = country
		self.sources = sources
		self.q = q
		self.pageSize = pageSize
	}

	func fetchFreshTopHeadlines(completion: Completion?) {
		topHeadlinesFetchingTask?.cancel()
		topHeadlines.removeAll()
		setIsFetching(to: false)
		fetchTopHeadlines(page: 1, completion: completion)
	}

	func fetchMoreTopHeadlines(completion: Completion?) {
		fetchTopHeadlines(page: nextPage, completion: completion)
	}

	private func fetchTopHeadlines(page: Int, completion: Completion?) {
		guard !isFetching else {
			completion?(.fetchingInProgress)
			return
		}
		setIsFetching(to: true)

		print("Page:", page)
		topHeadlinesFetchingTask = newsRepository.getTopHeadlines(
			category: category?.rawValue,
			language: language?.rawValue,
			country: country?.rawValue,
			sources: sources?.compactMap { $0.id }.joined(separator: ","),
			q: q,
			pageSize: pageSize,
			page: page) { [weak self] result in
				guard let strongSelf = self else {
					completion?(.unknownError)
					return
				}
				var resultError: NewsDataProviderError?
				switch result {
				case .success(let data):
					do {
						let response = try JSONDecoder().decode(TopHeadlinesResponse.self, from: data)
						guard response.status == .ok else {
							completion?(.fetchingError(response.code, response.message))
							strongSelf.setIsFetching(to: false)
							return
						}
						let fetchedArticles = response.articles ?? []
						print("Got \(fetchedArticles.count) top headlines of \(response.totalResults ?? 0) from server")
						strongSelf.topHeadlines.append(contentsOf: fetchedArticles)
						if (fetchedArticles.count < strongSelf.pageSize) ||
							(strongSelf.topHeadlines.count == response.totalResults) {
							resultError = .noMoreData
						}
						let totalFetched = self?.topHeadlines.count ?? 0
						print("Provider has \(totalFetched) top headlines")
					} catch {
						resultError = .parsingError(error)
					}
				case .failure(let error):
					resultError = .repositoryError(error)
				}
				strongSelf.setIsFetching(to: false)
				completion?(resultError) }
	}

	private func setIsFetching(to isFetching: Bool) {
		isFetchingLock.lock()
		self.isFetching = false
		isFetchingLock.unlock()
	}

}
