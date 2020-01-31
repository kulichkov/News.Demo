//
//  NewsNavigationController.swift
//  News.Demo
//
//  Created by Mikhail Kulichkov on 30.01.2020.
//  Copyright © 2020 Kulichkov. All rights reserved.
//

import UIKit

class NewsNavigationController: UINavigationController {
	var autorotation: Bool = true

	override var shouldAutorotate: Bool { autorotation }
}
