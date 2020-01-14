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

	func fill(article: Article) {
		dateLabel.text = article.publishedAt
		titleLabel.text = article.title
		authorLabel.text = article.author
		descriptionLabel.text = article.description
		sourceLabel.text = article.source?.name
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
