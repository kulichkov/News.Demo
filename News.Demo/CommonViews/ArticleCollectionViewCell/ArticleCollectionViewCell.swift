//
//  ArticleCollectionViewCell.swift
//  News.Demo
//
//  Created by Mikhail Kulichkov on 13.01.2020.
//  Copyright © 2020 Kulichkov. All rights reserved.
//

import UIKit

class ArticleCollectionViewCell: UICollectionViewCell {
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var authorLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var sourceLabel: UILabel!
	@IBOutlet weak var backgroundImageView: UIImageView!
	var urlToImage: String?
	var backgroundImage: UIImage? {
		set {
			DispatchQueue.main.async { [weak self] in
				guard let strongSelf = self else { return }
				UIView.transition(
					with: strongSelf.backgroundImageView,
					duration: 0.2,
					options: .transitionCrossDissolve,
					animations: { strongSelf.backgroundImageView.image = newValue },
					completion: nil)
			}
		}
		get { backgroundImageView.image }
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		dateLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
		titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
		authorLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
		descriptionLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
		sourceLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
		backgroundImageView.image = nil
	}

	func fill(article: Article) {
		dateLabel.text = article.publishedAt
		titleLabel.text = article.title
		authorLabel.text = article.author
		descriptionLabel.text = article.description
		sourceLabel.text = article.source?.name
		urlToImage = article.urlToImage
	}

	static func height(article: Article, cellWidth: CGFloat) -> CGFloat {
		let topCellPadding: CGFloat = 10
		let interItemPadding: CGFloat = 10
		let bottomCellPadding: CGFloat = 10
		let sidePadding: CGFloat = 10
		let contentWidth = cellWidth - 2 * sidePadding

		let dateHeight: CGFloat = article.publishedAt?.height(withConstrainedWidth: contentWidth, font: UIFont.preferredFont(forTextStyle: .caption1)) ?? 0
		let titleHeight: CGFloat = article.title?.height(withConstrainedWidth: contentWidth, font: UIFont.preferredFont(forTextStyle: .headline)) ?? 0
		let authorHeight: CGFloat = article.author?.height(withConstrainedWidth: contentWidth, font: UIFont.preferredFont(forTextStyle: .caption1)) ?? 0
		let descriptionHeight: CGFloat = article.description?.height(withConstrainedWidth: contentWidth, font: UIFont.preferredFont(forTextStyle: .subheadline)) ?? 0
		let sourceHeight: CGFloat = article.source?.name?.height(withConstrainedWidth: contentWidth, font: UIFont.preferredFont(forTextStyle: .caption1)) ?? 0
		let heights = [dateHeight, titleHeight, authorHeight, descriptionHeight, sourceHeight]
		let initialResult = topCellPadding + bottomCellPadding + interItemPadding * CGFloat(heights.count - 1)
		return heights.reduce(initialResult, +)
	}

}
