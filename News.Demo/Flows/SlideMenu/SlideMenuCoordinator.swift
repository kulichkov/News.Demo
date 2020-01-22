//
//  SlideMenuCoordinator.swift
//  News.Demo
//
//  Created by Mikhail Kulichkov on 17.01.2020.
//  Copyright © 2020 Kulichkov. All rights reserved.
//

import UIKit

class SlideMenuCoordinator: Coordinator {
	var childCoordinators: [Coordinator] = []
	var navigationController: UINavigationController?
	lazy var menuVC = SlideMenuViewController(menu: countryMenu)

	private let settingsMenuItem: MenuItem = "Settings"
	private lazy var categoryMenu = Menu(
		title: "Category",
		items: NewsCategory.allCases.sorted(),
		backItem: settingsMenuItem)

	private lazy var languageMenu: Menu = Menu(
		title: "Language",
		items: Language.allCases.sorted(),
		backItem: settingsMenuItem)

	private lazy var countryMenu: Menu = Menu(
		title: "Country",
		items: Country.allCases.sorted(),
		backItem: settingsMenuItem)

	private lazy var settingsMenu: Menu = Menu(
		title: "Setings",
		items: [categoryMenu, countryMenu, languageMenu],
		backItem: nil)

	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}

	func start() {
		navigationController?.present(menuVC, animated: false, completion: nil)
	}

}
