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
	@IBOutlet weak var topFadingView: FadingView!
	@IBOutlet weak var topFadingViewHeight: NSLayoutConstraint!
	@IBOutlet weak var bottomFadingView: FadingView!
	@IBOutlet weak var bottomFadingViewHeight: NSLayoutConstraint!
	@IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var dismissButton: UIButton!

	weak var delegate: SlideMenuViewControllerDelegate?
	var menu: Menu {
		didSet {
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
		setupFadingViews()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		updateFadings()
	}

	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)
		collectionView.reloadData()
	}

	// MARK: - Public functions
	func refreshUI() {
		menuTitleLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
		backItemButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title2)
		setCollectionViewHeight()
		collectionView.reloadData()
		setupFadingViews()
	}

	// MARK: - Private functions
	private func setupUI(menu: Menu) {
		dataSource.menu = menu
		collectionView.reloadData()

		menuTitleLabel.text = menu.title

		// Setting back item
		backItemButton.setTitle(menu.backItem?.title, for: .normal)
		backItemButton.isHidden = menu.backItem == nil

		setCollectionViewHeight()
	}

	private func setCollectionViewHeight() {
		let initialHeight: CGFloat = CGFloat(dataSource.count - 1) * collectionViewFlowLayout.minimumLineSpacing
		collectionViewHeightConstraint.constant = dataSource.reduce(initialHeight) { (result, item) -> CGFloat in
			result + MenuItemCollectionViewCell.height(item: item, cellWidth: collectionView.bounds.width)
		}
	}

	private func setupFadingViews() {
		let fadingViewHeight = max(44, MenuItemCollectionViewCell.height(
			item: "Item", cellWidth: collectionView.bounds.width))
		topFadingViewHeight.constant = fadingViewHeight
		bottomFadingViewHeight.constant = fadingViewHeight
	}

	private func updateFadings() {
		guard topFadingView.bounds.height > 0, bottomFadingView.bounds.height > 0 else { return }

		let scrollViewHeight: CGFloat = collectionView.bounds.height
		let scrollContentSizeHeight: CGFloat = collectionViewHeightConstraint.constant
		let scrollOffset: CGFloat = collectionView.contentOffset.y

		let topAlpha: CGFloat = max(0, min(scrollOffset, topFadingView.bounds.height)) / topFadingView.bounds.height
		let bottomAlpha: CGFloat = max(0, min(scrollContentSizeHeight - scrollViewHeight - scrollOffset, bottomFadingView.bounds.height)) / bottomFadingView.bounds.height

		topFadingView.alpha = topAlpha
		bottomFadingView.alpha = bottomAlpha
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

	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		updateFadings()
	}
}
