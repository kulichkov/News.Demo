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

extension SharingDelegate where Self: Coordinator {
	func controller(_ controller: UIViewController, didShare article: Article) {
		var activityItems: [Any] = []
		if let url = article.url {
			activityItems = [url as Any]
		} else {
			print("No url to share, sharing title and description...")
			activityItems = [
				article.title ?? "",
				article.description ?? ""
			]
		}
		let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
		navigationController?.present(activityVC, animated: true, completion: nil)
	}
}
