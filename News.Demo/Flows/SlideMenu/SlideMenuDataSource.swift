//
//  SlideMenuDataSource.swift
//  News.Demo
//
//  Created by Mikhail Kulichkov on 22.01.2020.
//  Copyright © 2020 Kulichkov. All rights reserved.
//

import UIKit

final class SlideMenuDataSource: NSObject {
	var menu: Menu
	var menuItemCellID: String

	init(menu: Menu, menuItemCellID: String) {
		self.menu = menu
		self.menuItemCellID = menuItemCellID
	}
}

extension SlideMenuDataSource: Collection {
	var startIndex: Int {
		menu.items.startIndex
	}

	var endIndex: Int {
		menu.items.endIndex
	}

	func index(after i: Int) -> Int {
		i + 1
	}

	subscript(index: Int) -> MenuItem {
		menu.items[index]
	}
}

extension SlideMenuDataSource: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return menu.items.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: menuItemCellID, for: indexPath) as? MenuItemCollectionViewCell else {
			return UICollectionViewCell()
		}
		cell.menuItemLabel.text = menu.items[indexPath.item].title
		return cell
	}
}
