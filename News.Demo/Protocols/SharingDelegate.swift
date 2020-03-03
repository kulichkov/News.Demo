//
//  SharingDelegate.swift
//  News.Demo
//
//  Created by Mikhail Kulichkov on 03.03.2020.
//  Copyright © 2020 Kulichkov. All rights reserved.
//

import UIKit

protocol SharingDelegate: class {
	func controller(_ controller: UIViewController, didShare article: Article)
}
