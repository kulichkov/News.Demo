//
//  Language+Extension.swift
//  News.Demo
//
//  Created by Mikhail Kulichkov on 21.01.2020.
//  Copyright © 2020 Kulichkov. All rights reserved.
//

import Foundation

extension Language: MenuItem {
	var title: String {
		switch self {
		case .arabic:
			return "Arabic"
		case .german:
		 	return "German"
		case .english:
			return "English"
		case .spanish:
			return "Spanish"
		case .french:
			return "French"
		case .hebrew:
			return "Hebrew"
		case .italian:
			return "Italian"
		case .dutch:
			return "Dutch"
		case .norwegian:
			return "Norwegian"
		case .portuguese:
			return "Portuguese"
		case .russian:
			return "Russian"
		case .swedish:
			return "Swedish"
		case .urdu:
			return "Urdu"
		case .chinese:
			return "Chinese"
		}
	}
}

extension Language: Comparable {
	static func < (lhs: Language, rhs: Language) -> Bool {
		lhs.title < rhs.title
	}
}

extension Language: EnumStringValue {
	static func makeValue(from rawValue: String) -> Language? {
		Language(rawValue: rawValue)
	}
}
