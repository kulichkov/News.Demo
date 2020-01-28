//
//  SlideMenuCoordinator.swift
//  News.Demo
//
//  Created by Mikhail Kulichkov on 17.01.2020.
//  Copyright © 2020 Kulichkov. All rights reserved.
//

import UIKit

class SlideMenuCoordinator: NSObject, Coordinator {
	var childCoordinators: [Coordinator] = []
	var navigationController: UINavigationController?
	lazy var menuVC: SlideMenuViewController = {
		let menuVC = SlideMenuViewController(menu: categoryMenu)
		menuVC.delegate = self
		return menuVC
	}()
	private var currentCoordinator: Coordinator? { childCoordinators.first }
	private lazy var interactor = MenuInteractor()

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

	init(coordinator: Coordinator) {
		self.childCoordinators = [coordinator]
	}

	func start() {
		(currentCoordinator as? MenuControlledCoordinator)?.delegate = self
		currentCoordinator?.start()
	}

	func showMenu() {
		menuVC.transitioningDelegate = self
		currentCoordinator?.navigationController?.present(menuVC, animated: true, completion: nil)
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

extension SlideMenuCoordinator: Refreshable {
	func refresh() {
		menuVC.refreshUI()
		refreshChildCoordinators()
	}
}

extension SlideMenuCoordinator: MenuControlledCoordinatorDelegate {
	func coordinatorDidPressMenuBarButton(_ coordinator: MenuControlledCoordinator) {
		showMenu()
	}
}

extension SlideMenuCoordinator: UIViewControllerTransitioningDelegate {
	func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return MenuPresentAnimator()
	}

//	func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//		return MenuDismissAnimator()
//	}

	func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
		return interactor.hasStarted ? interactor : nil
	}

	func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
		return interactor.hasStarted ? interactor : nil
	}

}
