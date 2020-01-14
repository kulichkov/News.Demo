//
//  UICollectionViewCell+Extension.swift
//  News.Demo
//
//  Created by Mikhail Kulichkov on 13.01.2020.
//  Copyright © 2020 Kulichkov. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
	static var nib: UINib { UINib(nibName: String(describing: self), bundle: nil) }
}
