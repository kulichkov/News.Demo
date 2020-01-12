//
//  NewsRepositoryProtocol.swift
//  News.Demo
//
//  Created by Mikhail Kulichkov on 08.01.2020.
//  Copyright © 2020 Kulichkov. All rights reserved.
//

import Foundation

enum NewsRepositoryError: Error {
	case urlError
	case requestError(Error?)
}

protocol NewsRepositoryProtocol {
	typealias Completion = (Result<Data, NewsRepositoryError>) -> Void

	/// This endpoint provides live top and breaking headlines for a country,
	/// specific category in a country, single source, or multiple sources.
	/// You can also search with keywords. Articles are sorted by the earliest date published first.
	/// This endpoint is great for retrieving headlines for display on news tickers or similar.
	/// - Parameters:
	///   - country: The 2-letter ISO 3166-1 code of the country you want to get headlines for.
	///   Possible options: ae ar at au be bg br ca ch cn co cu cz de eg fr gb gr hk hu id ie il in it jp
	///   kr lt lv ma mx my ng nl no nz ph pl pt ro rs ru sa se sg si sk th tr tw ua us ve za.
	///   Note: you can't mix this param with the sources param.
	///   - category: The category you want to get headlines for.
	///   Possible options: business entertainment general health science sports technology.
	///   Note: you can't mix this param with the sources param.
	///   - sources: A comma-seperated string of identifiers for the news sources or blogs you want headlines from.
	///   Use the /sources endpoint to locate these programmatically or look at the sources index.
	///   Note: you can't mix this param with the country or category params.
	///   - language: Language of articles. Possible options: ar de en es fr he it nl no pt ru se ud zh.
	///   Default: all languages.
	///   - q: Keywords or a phrase to search for.
	///   - pageSize: The number of results to return per page (request). 20 is the default, 100 is the maximum.
	///   - page: Use this to page through the results if the total results found is greater than the page size.
	///   - completion: Closure to execute on request completion.
	func getTopHeadlines(category: String?, language: String?, country: String?, sources: String?, q: String?, pageSize: Int?, page: Int?, completion: Completion?) -> URLSessionTask?
}
