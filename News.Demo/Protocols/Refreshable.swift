//
//  Refreshable.swift
//  News.Demo
//
//  Created by Mikhail Kulichkov on 26.01.2020.
//  Copyright © 2020 Kulichkov. All rights reserved.
//

import Foundation

protocol Refreshable {
	func refresh()
}

extension Coordinator {
	func refreshChildCoordinators() {
		childCoordinators.forEach {
			($0 as? Refreshable)?.refresh()
		}
	}
}

extension Refreshable where Self: Coordinator {
	func refresh() {
		refreshChildCoordinators()
	}
}
