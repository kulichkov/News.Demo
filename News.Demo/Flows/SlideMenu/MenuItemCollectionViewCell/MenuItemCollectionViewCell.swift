//
//  MenuItemCollectionViewCell.swift
//  News.Demo
//
//  Created by Mikhail Kulichkov on 22.01.2020.
//  Copyright © 2020 Kulichkov. All rights reserved.
//

import UIKit

class MenuItemCollectionViewCell: UICollectionViewCell {
	private var selectedTextColor: UIColor { .white }
	private var deselectedTextColor: UIColor { .gray }
	@IBOutlet weak var menuItemLabel: UILabel! {
		didSet {
			menuItemLabel.textColor = deselectedTextColor
		}
	}

	override var isSelected: Bool {
		didSet {
			super.isSelected = isSelected
			menuItemLabel.textColor = isSelected ? selectedTextColor : deselectedTextColor
		}
	}

	override var isHighlighted: Bool {
		didSet {
			UIView.animate(withDuration: 0.1) {
				self.menuItemLabel.alpha = self.isHighlighted ? 0.3 : 1
			}
			super.isHighlighted = isHighlighted
		}
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		menuItemLabel.font = UIFont.preferredFont(forTextStyle: .title2)
	}

	static func height(item: MenuItem, cellWidth: CGFloat) -> CGFloat {
		item.title.height(
			withConstrainedWidth: cellWidth,
			font: UIFont.preferredFont(forTextStyle: .title2))
	}
}
