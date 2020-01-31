//
//  MenuControlledViewController.swift
//  News.Demo
//
//  Created by Mikhail Kulichkov on 26.01.2020.
//  Copyright © 2020 Kulichkov. All rights reserved.
//

import UIKit

protocol MenuControlledViewControllerDelegate: class {
	func viewControllerDidPressMenuBarButton(_ viewController: MenuControlledViewController)
}

class MenuControlledViewController: UIViewController {
	weak var delegate: MenuControlledViewControllerDelegate?

	var autorotation: Bool = true

	override var shouldAutorotate: Bool { autorotation }

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Menu Controlled"
		navigationItem.leftBarButtonItem = UIBarButtonItem(
			image: #imageLiteral(resourceName: "menu_icon"), style: .plain, target: self, action: #selector(menuBarButtonPressed))
	}

	@objc
	private func menuBarButtonPressed(_ sender: UIBarButtonItem) {
		delegate?.viewControllerDidPressMenuBarButton(self)
	}
}
