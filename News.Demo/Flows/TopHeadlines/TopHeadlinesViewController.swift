//
//  TopHeadlinesViewController.swift
//  News.Demo
//
//  Created by Mikhail Kulichkov on 13.01.2020.
//  Copyright © 2020 Kulichkov. All rights reserved.
//

import UIKit

class TopHeadlinesViewController: MenuControlledViewController {
	private let kArticleCellID = "ArticleCell"
	private let kActivityFooterID = "ActivityFooter"
	private let contentSidePadding: CGFloat = 10
	private let fetchingPoint: CGFloat = 0.8
	private var isFetching: Bool = false
	// TODO: Come up with more good idea of refreshing
	private let dataSource: TopHeadlinesDataSource

	private var hasToReload: Bool {
		collectionView.indexPathsForVisibleItems.isEmpty ||
		!collectionView.indexPathsForVisibleSupplementaryElements(
			ofKind: UICollectionView.elementKindSectionFooter).isEmpty
	}
	private var isMainActivityVisible: Bool = false {
		didSet {
			switch isMainActivityVisible {
			case true:
				mainActivityView.startAnimating()
			case false:
				mainActivityView.stopAnimating()
			}
		}
	}
	private var isActivityFooterVisible: Bool = false {
		didSet {
			let context = UICollectionViewFlowLayoutInvalidationContext()
			let elementsKind = UICollectionView.elementKindSectionFooter
			let indexPaths = collectionView.indexPathsForVisibleSupplementaryElements(ofKind: elementsKind)
			context.invalidateSupplementaryElements(ofKind: elementsKind, at: indexPaths)
			flowLayout.invalidateLayout(with: context)
		}
	}
	private lazy var refreshControl: UIRefreshControl = {
		let control = UIRefreshControl()
		control.tintColor = .white
		control.addTarget(self, action: #selector(refreshControlValueChanged), for: .valueChanged)
		return control
	}()

	@IBOutlet weak var mainActivityView: UIActivityIndicatorView!
	@IBOutlet weak var collectionView: UICollectionView! {
		didSet {
			collectionView.dataSource = dataSource
			collectionView.register(ArticleCollectionViewCell.nib, forCellWithReuseIdentifier: kArticleCellID)
			collectionView.register(ActivityCollectionReusableView.nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: kActivityFooterID)
			collectionView.refreshControl = refreshControl
		}
	}
	@IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

	init(dataProvider: NewsDataProviderProtocol) {
		dataSource = TopHeadlinesDataSource(
			dataProvider: dataProvider, articleCellID: kArticleCellID, activityViewID: kActivityFooterID)
		super.init(nibName: String(describing: type(of: self)), bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Top Headlines"
		fetch()
	}

	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)
		collectionView.reloadData()
	}

	func refreshAppearance() {
		print("Refreshing appearance")
		collectionView.reloadData()
	}

	@objc
	private func refreshControlValueChanged(_ sender: UIRefreshControl) {
		collectionView.sendSubviewToBack(refreshControl)
		dataSource.refresh { [weak self] error in
			self?.refreshControl.endRefreshing()
			self?.collectionView.reloadData()
			print(error ?? "NO ERROR")
		}
	}

	private func fetch() {
		guard !isFetching else {
			print("dataSource is fetching already...")
			return
		}
		guard !dataSource.noMoreData else {
			print("There's no more data on server...")
			return
		}
		isFetching = true
		isActivityFooterVisible = !dataSource.isEmpty
		isMainActivityVisible = dataSource.isEmpty
		dataSource.fetch { [weak self] error in
			print(error ?? "NO ERROR")
			guard let strongSelf = self else { return }
			strongSelf.isActivityFooterVisible = false
			strongSelf.isMainActivityVisible = false
			strongSelf.collectionView.reloadData()
			strongSelf.isFetching = false
		}
	}
}

extension TopHeadlinesViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width = collectionView.bounds.width - 2 * contentSidePadding
		let height = ArticleCollectionViewCell.height(article: dataSource[indexPath.item], cellWidth: width)
		return CGSize(width: width, height: height)
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
		return CGSize(width: collectionView.bounds.width, height: isActivityFooterVisible ? 50 : 0)
	}
}

extension TopHeadlinesViewController: UICollectionViewDelegate {
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let fullOffset = scrollView.contentSize.height - scrollView.bounds.height
		print(String(format: "%0.2f", scrollView.contentOffset.y / fullOffset))
		if scrollView.contentOffset.y > 0, scrollView.contentOffset.y >= fetchingPoint * fullOffset {
			//print("==== Offset to FETCH")
			fetch()
		}
	}
}
