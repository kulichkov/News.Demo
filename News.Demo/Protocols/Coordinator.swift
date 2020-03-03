//
//  Coordinator.swift
//  News.Demo
//
//  Created by Mikhail Kulichkov on 07.01.2020.
//  Copyright © 2020 Kulichkov. All rights reserved.
//

import UIKit

protocol Coordinator: class {
	var parentCoordinator: Coordinator? { get }
	var childCoordinators: [Coordinator] { get set }
	var navigationController: UINavigationController? { get }

	func start()
	func childCoordinatorDidFinish(_ coordinator: Coordinator?)
}

extension Coordinator {
	func childCoordinatorDidFinish(_ child: Coordinator?) {
		guard let position = childCoordinators.firstIndex(where: { $0 === child }) else {
			return
		}
		childCoordinators.remove(at: position)
	}
}

protocol Coordinated where Self: UIViewController {
	var coordinator: Coordinator? { get }
}
