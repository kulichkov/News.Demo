//
//  NewsNavigationController.swift
//  News.Demo
//
//  Created by Mikhail Kulichkov on 30.01.2020.
//  Copyright © 2020 Kulichkov. All rights reserved.
//

import UIKit

class NewsNavigationController: UINavigationController {
	var autorotation: Bool = true {
		didSet {
			viewControllers.forEach {
				($0 as? MenuControlledViewController)?.autorotation = autorotation
			}
		}
	}

	override var shouldAutorotate: Bool {
		if #available(iOS 13.0, *) {
			return autorotation
		} else {
			return true
		}
	}
}
