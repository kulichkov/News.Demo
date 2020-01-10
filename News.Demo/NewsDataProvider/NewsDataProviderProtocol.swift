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
	case parsingError(Error)
	case repositoryError(NewsRepositoryError)
	case fetchingError(String?, String?)
}

protocol NewsDataProviderProtocol {
	typealias Completion = (NewsDataProviderError?) -> Void
	var topHeadlines: [Article] { get }
	func fetchTopHeadlines(category: NewsCategory?, language: Language?, country: Country?, sources: [Source]?, q: String?, pageSize: Int?, page: Int?, completion: Completion?)
}
