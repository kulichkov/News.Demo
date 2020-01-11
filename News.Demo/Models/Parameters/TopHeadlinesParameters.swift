//
//  TopHeadlinesParameters.swift
//  News.Demo
//
//  Created by Mikhail Kulichkov on 10.01.2020.
//  Copyright © 2020 Kulichkov. All rights reserved.
//

import Foundation

struct TopHeadlinesParameters: Equatable {
	var category: NewsCategory?
	var language: Language?
	var country: Country?
	var sources: [Source]?
	var q: String?
	var pageSize: Int?
	var page: Int?
}
