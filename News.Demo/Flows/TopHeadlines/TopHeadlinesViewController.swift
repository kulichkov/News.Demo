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
	private let article = Article(
		source: nil,
		author: "Автор",
		title: "Заголовок Заголовок Заголовок Заголовок Заголовок Заголовок",
		description: "Подробности Подробности Подробности Подробности",
		url: nil,
		urlToImage: nil,
		publishedAt: "Дата")

	@IBOutlet weak var collectionView: UICollectionView! {
		didSet {
			collectionView.register(ArticleCollectionViewCell.nib, forCellWithReuseIdentifier: kArticleCellID)
		}
	}
	@IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

	init() {
		super.init(nibName: String(describing: type(of: self)), bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Top Headlines"
		navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu_icon"), style: .plain, target: nil, action: nil)

	}

	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)
		collectionView.reloadData()
	}
}

extension TopHeadlinesViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 3
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kArticleCellID, for: indexPath) as? ArticleCollectionViewCell else {
			return UICollectionViewCell()
		}
		cell.fill(article: article)
		return cell
	}
}

extension TopHeadlinesViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width = collectionView.bounds.width - 2 * contentSidePadding
		let height = ArticleCollectionViewCell.height(article: article, cellWidth: width)
		return CGSize(width: width, height: height)
	}
}
