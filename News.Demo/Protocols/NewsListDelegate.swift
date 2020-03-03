//
//  NewsListDelegate.swift
//  News.Demo
//
//  Created by Mikhail Kulichkov on 02.03.2020.
//  Copyright © 2020 Kulichkov. All rights reserved.
//

import UIKit

protocol NewsListDelegate: class {
	func controller(_ controller: UIViewController, didSelectArticle article: Article)
}
