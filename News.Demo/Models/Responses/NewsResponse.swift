//
//  NewsResponse.swift
//  News.Demo
//
//  Created by Mikhail Kulichkov on 08.01.2020.
//  Copyright © 2020 Kulichkov. All rights reserved.
//

import Foundation

protocol NewsResponse: Codable {
	var status: ResponseStatus? { get }
	var code: String? { get }
	var message: String? { get }
}
