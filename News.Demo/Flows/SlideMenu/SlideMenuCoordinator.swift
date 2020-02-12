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
	weak var menuVC: SlideMenuViewController?
	private var settings = Settings()
	private var currentCoordinator: MenuControlledCoordinator? {
		childCoordinators.first as? MenuControlledCoordinator
	}
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

	init(coordinator: MenuControlledCoordinator) {
		self.childCoordinators = [coordinator]
		super.init()
		currentCoordinator?.delegate = self
	}

	func start() {
		currentCoordinator?.start()
	}

	func showMenu() {
		let newMenuVC = SlideMenuViewController(menu: categoryMenu)
		menuVC = newMenuVC
		newMenuVC.delegate = self
		newMenuVC.transitioningDelegate = self
		newMenuVC.modalPresentationStyle = .fullScreen
		currentCoordinator?.navigationController?.present(newMenuVC, animated: true)
	}

	func hideMenu() {
		menuVC?.transitioningDelegate = self
		menuVC?.dismiss(animated: true)
	}

	func handlePanRecognizer(_ panGestureRecognizer: UIPanGestureRecognizer, view: UIView, direction: MenuSlideDirection) {
		let translation = panGestureRecognizer.translation(in: view)
		let progress = MenuHelper.calculateProgress(translationInView: translation, viewBounds: view.bounds, direction: direction)

		MenuHelper.mapGestureStateToInteractor(
			gestureState: panGestureRecognizer.state,
			progress: progress,
			interactor: interactor,
			triggerSegue: { direction == .right ? showMenu() : hideMenu() })
	}
}

extension SlideMenuCoordinator: SlideMenuViewControllerDelegate {
	func controller(_ controller: SlideMenuViewController, didPanGestureWithRecognizer panGestureRecognizer: UIPanGestureRecognizer) {
		handlePanRecognizer(panGestureRecognizer, view: controller.view, direction: .left)
	}

	func controllerDidPressDismissButton(_ controller: SlideMenuViewController) {
		hideMenu()
	}

	func controller(_ controller: SlideMenuViewController, didPressItem item: MenuItem) {
		if let menu = item as? Menu {
			menuVC?.menu = menu
		} else if let language = item as? Language {
			print("language selected:", language.title)
			settings.language = language
		} else if let category = item as? NewsCategory {
			print("category selected:", category.title)
			settings.category = category
		} else if let country = item as? Country {
			print("country selected:", country.title)
			settings.country = country
		} else if let item = item as? String {
			switch item {
			case settingsMenuItem:
				menuVC?.menu = settingsMenu
			default:
				break
			}
		}
	}
}

extension SlideMenuCoordinator: Refreshable {
	func refresh() {
		menuVC?.refreshUI()
		refreshChildCoordinators()
	}
}

extension SlideMenuCoordinator: MenuControlledCoordinatorDelegate {
	func coordinator(_ coordinator: MenuControlledCoordinator, didHandlePanGestureRecognizer panGestureRecognizer: UIPanGestureRecognizer) {
		handlePanRecognizer(panGestureRecognizer, view: coordinator.viewController.view, direction: .right)
	}

	func coordinatorDidPressMenuBarButton(_ coordinator: MenuControlledCoordinator) {
		showMenu()
	}
}

extension SlideMenuCoordinator: UIViewControllerTransitioningDelegate {
	func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return MenuPresentAnimator()
	}

	func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return MenuDismissAnimator()
	}

	func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
		return interactor.hasStarted ? interactor : nil
	}

	func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
		return interactor.hasStarted ? interactor : nil
	}

}
