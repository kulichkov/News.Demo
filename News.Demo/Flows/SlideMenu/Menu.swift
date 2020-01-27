//
//  Menu.swift
//  News.Demo
//
//  Created by Mikhail Kulichkov on 20.01.2020.
//  Copyright © 2020 Kulichkov. All rights reserved.
//

import Foundation

protocol MenuItem {
	var title: String { get }
}

struct Menu {
	let title: String
	let items: [MenuItem]
	let backItem: MenuItem?
}

extension Menu: MenuItem {}

extension Menu: Equatable {
	static func == (lhs: Menu, rhs: Menu) -> Bool {
		lhs.title == rhs.title &&
			lhs.items.map { $0.title } == rhs.items.map { $0.title }
	}
}
