//
//  ArticlesResponse.swift
//  News.Demo
//
//  Created by Mikhail Kulichkov on 08.01.2020.
//  Copyright © 2020 Kulichkov. All rights reserved.
//

import Foundation

struct ArticlesResponse: NewsResponse {
	let status: ResponseStatus?
	let code: String?
	let message: String?
	
	let totalResults: Int?
	let articles: [Article]?
}
