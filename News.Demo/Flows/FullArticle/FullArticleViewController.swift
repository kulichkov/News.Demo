//
//  FullArticleViewController.swift
//  News.Demo
//
//  Created by Mikhail Kulichkov on 03.03.2020.
//  Copyright © 2020 Kulichkov. All rights reserved.
//

import UIKit
import WebKit

class FullArticleViewController: UIViewController, Coordinated {
	@IBOutlet weak var articleWebView: WKWebView! {
		didSet {
			setArticle(article)
		}
	}

	weak var coordinator: Coordinator?
	weak var sharingDelegate: SharingDelegate?
	private let article: Article

	init(with article: Article) {
		self.article = article
		super.init(nibName: String(describing: type(of: self)), bundle: nil)
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .action,
			target: self,
			action: #selector(shareBarButtonPressed))
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private functions
	private func setArticle(_ article: Article) {
		guard let urlString = article.url, let url = URL(string: urlString) else {
			print("Wrong url")
			return
		}
		articleWebView.load(URLRequest(url: url))
		title = article.title
	}

	@objc
	private func shareBarButtonPressed(_ sender: UIBarButtonItem) {
		sharingDelegate?.controller(self, didShare: article)
	}
}
