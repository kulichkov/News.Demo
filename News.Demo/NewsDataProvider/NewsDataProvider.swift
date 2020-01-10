//
//  NewsDataProvider.swift
//  News.Demo
//
//  Created by Mikhail Kulichkov on 09.01.2020.
//  Copyright © 2020 Kulichkov. All rights reserved.
//

import Foundation

final class NewsDataProvider: NewsDataProviderProtocol {
	let newsRepository: NewsRepositoryProtocol
	var topHeadlines: [Article] = []

	private var completions: [Completion] = []
	private var isFetchingTopHeadlines: Bool = false

	init(newsRepository: NewsRepositoryProtocol) {
		self.newsRepository = newsRepository
	}

	func fetchTopHeadlines(
		category: NewsCategory? = nil,
		language: Language? = nil,
		country: Country? = nil,
		sources: [Source]? = nil,
		q: String? = nil,
		pageSize: Int? = nil,
		page: Int? = nil,
		completion: Completion?) {
		guard !isFetchingTopHeadlines else {
			if let completion = completion { completions.append(completion) }
			return
		}

		newsRepository.getTopHeadlines(
			category: category?.rawValue,
			language: language?.rawValue,
			country: country?.rawValue,
			sources: sources?.compactMap { $0.id }.joined(separator: ","),
			q: q,
			pageSize: pageSize,
			page: page) { [weak self] result in
				switch result {
				case .success(let data):
					do {
						let response = try JSONDecoder().decode(TopHeadlinesResponse.self, from: data)
						guard response.status == .ok else {
							completion?(.fetchingError(response.code, response.message))
							return
						}
						print("Got \(response.articles?.count ?? 0) top headlines from server")
						self?.topHeadlines = response.articles ?? []
					} catch {
						completion?(.parsingError(error))
					}
				case .failure(let error):
					completion?(.repositoryError(error))
				} }
	}

}
