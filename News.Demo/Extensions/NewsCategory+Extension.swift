//
//  NewsCategory+Extension.swift
//  News.Demo
//
//  Created by Mikhail Kulichkov on 21.01.2020.
//  Copyright © 2020 Kulichkov. All rights reserved.
//

import Foundation

extension NewsCategory: MenuItem {
	var title: String {
		self.rawValue.capitalized
	}
}

extension NewsCategory: Comparable {
	static func < (lhs: NewsCategory, rhs: NewsCategory) -> Bool {
		lhs.title < rhs.title
	}
}

extension NewsCategory: EnumStringValue {
	static func makeValue(from rawValue: String) -> NewsCategory? {
		NewsCategory(rawValue: rawValue)
	}
}
