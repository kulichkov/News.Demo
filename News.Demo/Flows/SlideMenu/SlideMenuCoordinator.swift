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
	lazy var menuVC = SlideMenuViewController()

	private let settingsMenuItem: MenuItem = "Settings"
	private lazy var categoriesMenu = Menu(
		title: "Categories",
		items: NewsCategory.allCases.sorted(),
		backItemTitle: settingsMenuItem)

	private lazy var languagesMenu: Menu = Menu(
		title: "Languages",
		items: Language.allCases.sorted(),
		backItemTitle: settingsMenuItem)

	private lazy var countriesMenu: Menu = Menu(
		title: "Countries",
		items: Country.allCases.sorted(),
		backItemTitle: settingsMenuItem)

	private lazy var settingsMenu: Menu = Menu(
		title: "Setings",
		items: [categoriesMenu, countriesMenu, languagesMenu],
		backItemTitle: nil)

	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}

	func start() {
		navigationController?.present(menuVC, animated: false, completion: nil)
	}

}
