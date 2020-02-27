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
	func controllerDidPressDismissButton(_ controller: SlideMenuViewController)
	func controller(_ controller: SlideMenuViewController, didPanGestureWithRecognizer panGestureRecognizer: UIPanGestureRecognizer)
}

class SlideMenuViewController: UIViewController {
	@IBOutlet weak var menuTitleLabel: UILabel!
	@IBOutlet weak var backItemButton: UIButton! {
		didSet {
			backItemButton.setTitle("", for: .normal)
		}
	}
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
	@IBOutlet weak var dismissButton: UIButton! {
		didSet {
			dismissButton.addTarget(self, action: #selector(dismissButtonPressed), for: .touchUpInside)
		}
	}

	weak var delegate: SlideMenuViewControllerDelegate?
	var menu: Menu {
		didSet {
			setupUI(menu: menu)
		}
	}

	private let kMenuItemCellID = "MenuItemCellID"
	private lazy var dataSource = SlideMenuDataSource(menu: menu, menuItemCellID: kMenuItemCellID)
	private let settings = Settings()

	init(menu: Menu) {
		self.menu = menu
		super.init(nibName: String(describing: type(of: self)), bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		view.frame.size = UIScreen.main.bounds.size
		view.layoutIfNeeded()
		backItemButton.addTarget(self, action: #selector(backItemButtonPressed), for: .touchUpInside)
		let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
		view.addGestureRecognizer(panGestureRecognizer)
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
		coordinator.animate(alongsideTransition: nil) { [weak self] _ in
			self?.makeOrUpdateSnapshot(animated: true) }
	}

	// MARK: - Public functions
	func refreshUI() {
		menuTitleLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
		backItemButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title2)
		setCollectionViewHeight()
		collectionView.reloadData()
		setupFadingViews()
	}

	@discardableResult
	func makeOrUpdateSnapshot(animated: Bool) -> UIView? {
		presentingViewController?.view.frame = view.frame
		(presentingViewController as? UINavigationController)?.topViewController?.view.frame = view.frame

		guard let snapshot = presentingViewController?.view.snapshotView(afterScreenUpdates: true) else {
			return nil
		}
		snapshot.isUserInteractionEnabled = false
		snapshot.layer.shadowOpacity = 1
		snapshot.layer.shadowRadius = 20
		snapshot.frame.origin.y -= dismissButton.frame.origin.y

		if let oldSnapshot = dismissButton.subviews.first {
			dismissButton.insertSubview(snapshot, belowSubview: oldSnapshot)
			if animated {
				UIView.transition(
					from: oldSnapshot,
					to: snapshot,
					duration: 0.3,
					options: .transitionCrossDissolve,
					completion: nil)
			} else {
				oldSnapshot.removeFromSuperview()
			}
		}

		return snapshot
	}

	// MARK: - Private functions

	private func selectCurrentItem(in menu: Menu) {
		var item: Int?
		if let languages = menu.items as? [Language] {
			item = languages.firstIndex(of: settings.language)
		} else if let categories = menu.items as? [NewsCategory] {
			item = categories.firstIndex(of: settings.category)
		} else if let countries = menu.items as? [Country] {
			item = countries.firstIndex(of: settings.country)
		}

		if let item = item {
			collectionView.selectItem(
				at: IndexPath(item: item, section: 0),
				animated: false,
				scrollPosition: .centeredVertically)
		}
	}

	private func setupUI(menu: Menu) {
		dataSource.menu = menu
		collectionView.reloadData()

		menuTitleLabel.text = menu.title

		// Setting back item
		backItemButton.setTitle(menu.backItem?.title, for: .normal)
		backItemButton.isHidden = menu.backItem == nil

		setCollectionViewHeight()
		selectCurrentItem(in: menu)
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

	@objc
	private func dismissButtonPressed(_ sender: UIButton) {
		delegate?.controllerDidPressDismissButton(self)
	}

	@objc
	private func handlePanGesture(sender: UIPanGestureRecognizer) {
		delegate?.controller(self, didPanGestureWithRecognizer: sender)
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
		collectionView.cellForItem(at: indexPath)?.isSelected = true
		delegate?.controller(self, didPressItem: dataSource[indexPath.item])
	}

	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		updateFadings()
	}
}
