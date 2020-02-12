//
//  NewsCategory.swift
//  News.Demo
//
//  Created by Mikhail Kulichkov on 08.01.2020.
//  Copyright © 2020 Kulichkov. All rights reserved.
//

import Foundation

enum NewsCategory: String, Codable, CaseIterable {
	case all = ""
	case business, entertainment, general, health, science, sports, technology
}
