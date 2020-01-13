//
//  UINavigationBar+Extension.swift
//  News.Demo
//
//  Created by Mikhail Kulichkov on 13.01.2020.
//  Copyright © 2020 Kulichkov. All rights reserved.
//

import UIKit

extension UINavigationBar {
	static func setBlackAppearance() {
		let appearance = UINavigationBar.appearance()
		appearance.tintColor = .white
		appearance.barStyle = .black
		appearance.isTranslucent = false
		appearance.shadowImage = UIImage()
	}
}
