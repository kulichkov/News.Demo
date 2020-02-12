//
//  EnumStringValue.swift
//  News.Demo
//
//  Created by Mikhail Kulichkov on 12.02.2020.
//  Copyright © 2020 Kulichkov. All rights reserved.
//

import Foundation

protocol EnumStringValue {
	static func makeValue(from rawValue: String) -> Self?
}
