//
//  TopHeadlinesViewController.swift
//  News.Demo
//
//  Created by Mikhail Kulichkov on 13.01.2020.
//  Copyright © 2020 Kulichkov. All rights reserved.
//

import UIKit

class TopHeadlinesViewController: UIViewController {
	private let kArticleCellID = "ArticleCell"
	private let contentSidePadding: CGFloat = 10
	private let dataSource: TopHeadlinesDataSource

	@IBOutlet weak var collectionView: UICollectionView! {
		didSet {
			collectionView.dataSource = dataSource
			collectionView.register(ArticleCollectionViewCell.nib, forCellWithReuseIdentifier: kArticleCellID)
		}
	}
	@IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

	init(dataProvider: NewsDataProviderProtocol) {
		dataSource = TopHeadlinesDataSource(
			dataProvider: dataProvider, articleCellReuseID: kArticleCellID)
		super.init(nibName: String(describing: type(of: self)), bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Top Headlines"
		navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu_icon"), style: .plain, target: nil, action: nil)
		dataSource.fetch { [weak collectionView] error in
			collectionView?.reloadData()
			print(error ?? "NO ERROR")
		}
	}

	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)
		collectionView.reloadData()
	}
}

extension TopHeadlinesViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width = collectionView.bounds.width - 2 * contentSidePadding
		let height = ArticleCollectionViewCell.height(article: dataSource[indexPath.item], cellWidth: width)
		return CGSize(width: width, height: height)
	}
}
