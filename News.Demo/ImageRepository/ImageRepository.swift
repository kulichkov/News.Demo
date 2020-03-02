//
//  ImageRepository.swift
//  News.Demo
//
//  Created by Mikhail Kulichkov on 02.03.2020.
//  Copyright © 2020 Kulichkov. All rights reserved.
//

import UIKit

class ImageRepository: ImageRepositoryProtocol {
	private let cache = NSCache<NSStringURL, UIImage>()

	// MARK: - Public functions
	func getImage(withURL url: StringURL, completion: @escaping Completion) throws {
		if let image = getImage(withURL: url, from: cache) {
			completion(.success(image))
		} else {
			try downloadImage(withURL: url) { [weak self] result in
				guard let strongSelf = self else { return }
				switch result {
				case .success(let image):
					strongSelf.setImage(image, withURL: url, to: strongSelf.cache)
				default: break
				}
				completion(result)
			}
		}
	}

	// MARK: - Private functions
	private func getImage(withURL url: StringURL, from cache: NSCache<NSStringURL, UIImage>) -> UIImage? {
		let key = NSStringURL(string: url)
		guard let image = cache.object(forKey: key) else { return nil }
		return image
	}

	private func setImage(_ image: UIImage, withURL url: StringURL, to cache: NSCache<NSStringURL, UIImage>) {
		cache.setObject(image, forKey: NSStringURL(string: url))
	}

	private func downloadImage(withURL url: StringURL, completion: @escaping Completion) throws {
		guard let url = URL(string: url) else {
			throw ImageRepositoryError.urlError
		}
		URLSession.shared.dataTask(with: url) { (data, _, error) in
			if let data = data {
				if let image = UIImage(data: data) {
					completion(.success(image))
				} else {
					completion(.failure(.dataConversionError))
				}
			} else {
				completion(.failure(.requestError(error)))
			}
		}.resume()
	}
}
