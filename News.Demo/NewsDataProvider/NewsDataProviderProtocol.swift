//
//  NewsDataProviderProtocol.swift
//  News.Demo
//
//  Created by Mikhail Kulichkov on 09.01.2020.
//  Copyright © 2020 Kulichkov. All rights reserved.
//

import Foundation

enum NewsDataProviderError: Error {
	case fetchingInProgress
	case noMoreData
	case unknownError
	case parsingError(Error)
	case repositoryError(NewsRepositoryError)
	case fetchingError(String?, String?)
}

protocol NewsDataProviderProtocol {
	typealias Completion = (NewsDataProviderError?) -> Void
	var topHeadlines: [Article] { get }
	func fetchFreshTopHeadlines(completion: Completion?)
	func fetchMoreTopHeadlines(completion: Completion?)

	func setCategory(_ value: NewsCategory?, completion: Completion?)
	func setLanguage(_ value: Language?, completion: Completion?)
	func setCountry(_ value: Country?, completion: Completion?)
	func setSources(_ value: [Source]?, completion: Completion?)
	func setQ(_ value: String?, completion: Completion?)
	func setPageSize(_ value: Int, completion: Completion?)
}
