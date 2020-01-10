//
//  NewsRepository.swift
//  News.Demo
//
//  Created by Mikhail Kulichkov on 08.01.2020.
//  Copyright © 2020 Kulichkov. All rights reserved.
//

import Foundation

class NewsRepository: NewsRepositoryProtocol {
	enum RequestType: String {
		case get = "GET"
		case post = "POST"
	}

	enum Endpoint: String {
		case topHeadlines = "top-headlines"
	}

	// Private properties
	private let baseURLString: String = "https://newsapi.org"
	private let version: String = "v2"
	private let xApiKeyField: String = "x-api-key"

	private func makeAndStartRequest(
		endpoint: Endpoint,
		type: RequestType,
		parameters: [String: String]? = nil,
		body: Data? = nil,
		completion: ((Result<Data, NewsRepositoryError>) -> Void)?) -> URLSessionTask? {
		let joinedURL = URL(string: baseURLString)?
			.appendingPathComponent(version)
			.appendingPathComponent(endpoint.rawValue)

		guard let url = joinedURL, var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
			completion?(.failure(.urlError))
			return nil
		}

		if type == .get {
			urlComponents.queryItems = parameters?.map { URLQueryItem(name: $0.key, value: $0.value) }
		}

		guard let requestURL = urlComponents.url else {
			completion?(.failure(.urlError))
			return nil
		}
		var urlRequest = URLRequest(url: requestURL)

		// Header
		urlRequest.httpMethod = type.rawValue
		urlRequest.httpBody = body
		urlRequest.addValue(Secret.newsAPIKey, forHTTPHeaderField: xApiKeyField)

		let task = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
			if let data = data {
				completion?(.success(data))
			} else {
				completion?(.failure(.requestError(error)))
			} }
		task.resume()
		return task
	}

	func getTopHeadlines(
		category: String? = nil,
		language: String? = nil,
		country: String? = nil,
		sources: String? = nil,
		q: String? = nil,
		pageSize: Int? = nil,
		page: Int? = nil,
		completion: Completion?) -> URLSessionTask? {

		var parameters: [String: String] = [:]
		parameters["category"] = category
		parameters["language"] = language
		parameters["country"] = country
		parameters["sources"] = sources
		parameters["q"] = q
		if let value = pageSize {
			parameters["pageSize"] = String(value)
		}
		if let value = page {
			parameters["page"] = String(value)
		}

		return makeAndStartRequest(
			endpoint: .topHeadlines,
			type: .get,
			parameters: parameters,
			completion: completion)
	}
}
