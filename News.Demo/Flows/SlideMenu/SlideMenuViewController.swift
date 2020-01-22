//
//  SlideMenuViewController.swift
//  News.Demo
//
//  Created by Mikhail Kulichkov on 19.01.2020.
//  Copyright © 2020 Kulichkov. All rights reserved.
//

import UIKit

protocol SlideMenuViewControllerDelegate: class {
	func controller(_ controller: SlideMenuViewController, didPressItem item: MenuItem)
}

class SlideMenuViewController: UIViewController {
	@IBOutlet weak var menuTitleLabel: UILabel!
	@IBOutlet weak var backItemButton: UIButton!
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!

	weak var delegate: SlideMenuViewControllerDelegate?
	var menu: Menu

	init(menu: Menu) {
		self.menu = menu
		super.init(nibName: String(describing: type(of: self)), bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI(menu: menu)
	}

	private func setupUI(menu: Menu) {
		menuTitleLabel.text = menu.title

		// Setting back item
		backItemButton.setTitle(menu.backItem?.title, for: .normal)
		backItemButton.isHidden = menu.backItem == nil

		collectionViewHeightConstraint.constant = 100
	}
}
