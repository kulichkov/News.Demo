//
//  Source.swift
//  News.Demo
//
//  Created by Mikhail Kulichkov on 08.01.2020.
//  Copyright © 2020 Kulichkov. All rights reserved.
//

import Foundation

struct Source: Codable, Equatable {
	let id: String?
	let name: String?
	let description: String?
	let url: String?
	let category: NewsCategory?
	let language: Language?
	let country: Country?
}
