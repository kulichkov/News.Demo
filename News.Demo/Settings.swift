//
//  Settings.swift
//  News.Demo
//
//  Created by Mikhail Kulichkov on 12.02.2020.
//  Copyright © 2020 Kulichkov. All rights reserved.
//

import Foundation

struct Settings {
	// MARK: - Public properties
	var language: Language {
		set { set(value: newValue.rawValue, forKey: languageKey) }
		get { getValue(key: languageKey, default: .english) }
	}
	var country: Country? {
		set { set(value: newValue?.rawValue, forKey: countryKey) }
		get { getValue(key: countryKey) }
	}
	var category: NewsCategory? {
		set { set(value: newValue?.rawValue, forKey: categoryKey) }
		get { getValue(key: categoryKey) }
	}

	// MARK: - Private properties
	private var languageKey: String { "language" }
	private var countryKey: String { "country" }
	private var categoryKey: String { "category" }
	private var defaultLanguage: Language { .english }

	// MARK: - Private functions
	private func getValue<T: EnumStringValue>(key: String, default: T) -> T {
		guard let savedRawValue = UserDefaults.standard.string(forKey: key) else {
			return `default`
		}
		return T.makeValue(from: savedRawValue) ?? `default`
	}

	private func getValue<T: EnumStringValue>(key: String) -> T? {
		guard let savedRawValue = UserDefaults.standard.string(forKey: key) else {
			return nil
		}
		return T.makeValue(from: savedRawValue)
	}

	private func set(value: String?, forKey key: String) {
		UserDefaults.standard.set(value, forKey: key)
	}
}
