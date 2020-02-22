//
//  NewsDataProvider.swift
//  News.Demo
//
//  Created by Mikhail Kulichkov on 09.01.2020.
//  Copyright © 2020 Kulichkov. All rights reserved.
//

import Foundation

final class NewsDataProvider: NewsDataProviderProtocol {
	// MARK: - Public properties
	var topHeadlines: [Article] = []

	// MARK: - Private properties
//	private var category: NewsCategory?
//	private var language: Language?
//	private var country: Country?
	private let settings = Settings()
	private var sources: [Source]?
	private var q: String?
	private var pageSize: Int

	private var nextPage: Int {
		pageSize > 0 ? (topHeadlines.count / pageSize) + 1 : 1
	}

	private var isFetching: Bool {
		topHeadlinesFetchingTask != nil
	}
	private var topHeadlinesFetchingTask: URLSessionTask?
	private let newsRepository: NewsRepositoryProtocol

	// MARK: - Initialization
	init(newsRepository: NewsRepositoryProtocol, sources: [Source]? = nil, q: String? = nil, pageSize: Int = 20) {
		self.newsRepository = newsRepository

//		self.category = category
//		self.language = language
//		self.country = country
		self.sources = sources
		self.q = q
		self.pageSize = pageSize
	}

	// MARK: - Public functions
	func fetchFreshTopHeadlines(completion: Completion?) {
		topHeadlinesFetchingTask?.cancel()
		topHeadlinesFetchingTask = nil
		fetchTopHeadlines(page: 1, completion: completion)
	}

	func fetchMoreTopHeadlines(completion: Completion?) {
		fetchTopHeadlines(page: nextPage, completion: completion)
	}

	func clearTopHeadlines(completion: Completion?) {
		topHeadlinesFetchingTask?.cancel()
		topHeadlinesFetchingTask = nil
		topHeadlines.removeAll()
		completion?(nil)
	}

	// Property setters with completion
//	func setCategory(_ value: NewsCategory?, completion: Completion?) {
//		category = value
//		fetchFreshTopHeadlines(completion: completion)
//	}
//	func setLanguage(_ value: Language?, completion: Completion?) {
//		language = value
//		fetchFreshTopHeadlines(completion: completion)
//	}
//	func setCountry(_ value: Country?, completion: Completion?) {
//		country = value
//		fetchFreshTopHeadlines(completion: completion)
//	}
	func setSources(_ value: [Source]?, completion: Completion?) {
		sources = value
		fetchFreshTopHeadlines(completion: completion)
	}
	func setQ(_ value: String?, completion: Completion?) {
		q = value
		fetchFreshTopHeadlines(completion: completion)
	}
	func setPageSize(_ value: Int, completion: Completion?) {
		pageSize = value
		fetchFreshTopHeadlines(completion: completion)
	}

	// MARK: - Private functions
	private func fetchTopHeadlines(page: Int, completion: Completion?) {
		guard !isFetching else {
			completion?(.fetchingInProgress)
			return
		}
		print("Page:", page)
		topHeadlinesFetchingTask = newsRepository.getTopHeadlines(
			category: settings.category.rawValue,
			language: settings.language.rawValue,
			country: settings.country.rawValue,
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
							strongSelf.topHeadlinesFetchingTask = nil
							return
						}
						let fetchedArticles = response.articles ?? []
						print("Got \(fetchedArticles.count) top headlines of \(response.totalResults ?? 0) from server")
						strongSelf.updateTopHeadlines(page: page, newHeadlines: fetchedArticles)
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
				strongSelf.topHeadlinesFetchingTask = nil
				completion?(resultError) }
	}

	private func updateTopHeadlines(page: Int, newHeadlines: [Article]) {
		if page > 1 {
			topHeadlines.append(contentsOf: newHeadlines)
		} else {
			topHeadlines = newHeadlines
		}
	}

}
