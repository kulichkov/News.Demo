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
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var menuTitleLabel: UILabel!
	@IBOutlet weak var itemsStackView: UIStackView!
	@IBOutlet weak var backItemButton: UIButton!

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

	private func makeItemButtons(menuItems: [MenuItem]) -> [UIButton] {
		var buttons: [UIButton] = []
		for (index, item) in menuItems.enumerated() {
			buttons.append(makeItemButton(menuItem: item, tag: index))
		}
		return buttons
	}

	private func makeItemButton(menuItem: MenuItem, tag: Int) -> UIButton {
		let button = UIButton(type: .system)
		button.contentHorizontalAlignment = .leading
		button.tintColor = .white
		button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title2)
		button.titleLabel?.lineBreakMode = .byTruncatingTail
		button.setTitle(menuItem.title, for: .normal)
		button.tag = tag
		button.addTarget(self, action: #selector(itemButtonPressed), for: .touchUpInside)
		return button
	}

	private func setupUI(menu: Menu) {
		menuTitleLabel.text = menu.title

		// Setting menu items
		itemsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
		makeItemButtons(menuItems: menu.items).forEach(itemsStackView.addArrangedSubview)

		// Setting back item button
		backItemButton.setTitle(menu.backItem?.title, for: .normal)
		backItemButton.addTarget(self, action: #selector(backItemButtonPressed), for: .touchUpInside)
	}

	@objc
	private func itemButtonPressed(_ sender: UIButton) {
		delegate?.controller(self, didPressItem: menu.items[sender.tag])
	}

	@objc
	private func backItemButtonPressed(_ sender: UIButton) {
		guard let item = menu.backItem else { return }
		delegate?.controller(self, didPressItem: item)
	}
}
