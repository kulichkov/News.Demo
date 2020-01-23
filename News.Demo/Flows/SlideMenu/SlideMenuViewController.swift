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
	@IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
	@IBOutlet weak var collectionView: UICollectionView! {
		didSet {
			collectionView.register(MenuItemCollectionViewCell.nib, forCellWithReuseIdentifier: kMenuItemCellID)
			collectionView.dataSource = dataSource
			collectionView.delegate = self
		}
	}
	@IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!

	weak var delegate: SlideMenuViewControllerDelegate?
	var menu: Menu {
		didSet {
			dataSource.menu = menu
			collectionView.reloadData()
			setupUI(menu: menu)
		}
	}

	private let kMenuItemCellID = "MenuItemCellID"
	private lazy var dataSource = SlideMenuDataSource(menu: menu, menuItemCellID: kMenuItemCellID)

	init(menu: Menu) {
		self.menu = menu
		super.init(nibName: String(describing: type(of: self)), bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		backItemButton.addTarget(self, action: #selector(backItemButtonPressed), for: .touchUpInside)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setupUI(menu: menu)
	}

	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)
		collectionView.reloadData()
	}

	private func setupUI(menu: Menu) {
		menuTitleLabel.text = menu.title

		// Setting back item
		backItemButton.setTitle(menu.backItem?.title, for: .normal)
		backItemButton.isHidden = menu.backItem == nil

		// Setting collection view height
		let initialHeight: CGFloat = CGFloat(dataSource.count - 1) * collectionViewFlowLayout.minimumLineSpacing
		collectionViewHeightConstraint.constant = dataSource.reduce(initialHeight) { (result, item) -> CGFloat in
			result + MenuItemCollectionViewCell.height(item: item, cellWidth: collectionView.bounds.width)
		}
	}

	@objc
	private func backItemButtonPressed(_ sender: UIButton) {
		guard let backItem = menu.backItem else { return }
		delegate?.controller(self, didPressItem: backItem)
	}
}

extension SlideMenuViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		CGSize(
			width: collectionView.bounds.width,
			height: MenuItemCollectionViewCell.height(
				item: dataSource[indexPath.item],
				cellWidth: collectionView.bounds.width))
	}
}

extension SlideMenuViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		delegate?.controller(self, didPressItem: dataSource[indexPath.item])
	}
}
