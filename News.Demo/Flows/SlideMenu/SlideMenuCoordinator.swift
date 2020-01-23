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
	lazy var menuVC: SlideMenuViewController = {
		let menuVC = SlideMenuViewController(menu: categoryMenu)
		menuVC.delegate = self
		return menuVC
	}()

	private let settingsMenuItem = "Settings"
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
		title: "Settings",
		items: [categoryMenu, countryMenu, languageMenu],
		backItem: nil)

	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}

	func start() {
		navigationController?.present(menuVC, animated: false, completion: nil)
	}

}

extension SlideMenuCoordinator: SlideMenuViewControllerDelegate {
	func controller(_ controller: SlideMenuViewController, didPressItem item: MenuItem) {
		if let menu = item as? Menu {
			menuVC.menu = menu
		} else if let language = item as? Language {
			print("language selected:", language.title)
		} else if let category = item as? NewsCategory {
			print("category selected:", category.title)
		} else if let country = item as? Country {
			print("country selected:", country.title)
		} else if let item = item as? String {
			switch item {
			case settingsMenuItem:
				menuVC.menu = settingsMenu
			default:
				break
			}
		}
	}
}
