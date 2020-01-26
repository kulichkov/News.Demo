//
//  Coordinator.swift
//  News.Demo
//
//  Created by Mikhail Kulichkov on 07.01.2020.
//  Copyright © 2020 Kulichkov. All rights reserved.
//

import UIKit

protocol Coordinator {
	var childCoordinators: [Coordinator] { get set }
	var navigationController: UINavigationController? { get set }

	func start()
}
