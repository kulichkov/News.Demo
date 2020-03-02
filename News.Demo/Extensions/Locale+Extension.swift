//
//  Locale+Extension.swift
//  News.Demo
//
//  Created by Mikhail Kulichkov on 02.03.2020.
//  Copyright © 2020 Kulichkov. All rights reserved.
//

import Foundation

extension Locale {
	static var preferredLocale: Locale {
		guard let preferredIdentifier = Locale.preferredLanguages.first else {
			return Locale.current
		}
		return Locale(identifier: preferredIdentifier)
	}
}
