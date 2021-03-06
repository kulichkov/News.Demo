//
//  ImageRepositoryProtocol.swift
//  News.Demo
//
//  Created by Mikhail Kulichkov on 02.03.2020.
//  Copyright © 2020 Kulichkov. All rights reserved.
//

import UIKit

enum ImageRepositoryError: Error {
	case urlError
	case requestError(Error?)
	case dataConversionError
}

enum ImageSource {
	case cache, network
}

protocol ImageRepositoryProtocol {
	typealias Completion = (Result<(UIImage, ImageSource), ImageRepositoryError>) -> Void
	typealias StringURL = String
	typealias NSStringURL = NSString
	func getImage(withURL url: StringURL, completion: @escaping Completion) throws
}
