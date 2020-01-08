//
//  Article.swift
//  News.Demo
//
//  Created by Mikhail Kulichkov on 08.01.2020.
//  Copyright © 2020 Kulichkov. All rights reserved.
//

import Foundation

struct Article: Codable, Equatable {
	let source: Source?
	let author: String?
	let title: String?
	let description: String?
	let url: String?
	let urlToImage: String?
	let publishedAt: String?
}
