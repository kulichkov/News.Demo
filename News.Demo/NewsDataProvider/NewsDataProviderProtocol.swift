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
}
