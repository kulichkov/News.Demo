//
//  Country+Extension.swift
//  News.Demo
//
//  Created by Mikhail Kulichkov on 21.01.2020.
//  Copyright © 2020 Kulichkov. All rights reserved.
//

import Foundation

extension Country: MenuItem {
	var title: String {
		switch self {
		case .argentina:
			return "Argentina"
		case .australia:
			return "Australia"
		case .austria:
			return "Austria"
		case .belgium:
			return "Belgium"
		case .brazil:
			return "Brazil"
		case .bulgaria:
			return "Bulgaria"
		case .canada:
			return "Canada"
		case .china:
			return "China"
		case .colombia:
			return "Colombia"
		case .cuba:
			return "Cuba"
		case .czechRepublic:
			return "Czech Republic"
		case .egypt:
			return "Egypt"
		case .france:
			return "France"
		case .germany:
			return "Germany"
		case .greece:
			return "Greece"
		case .hongKong:
			return "Hong Kong"
		case .hungary:
			return "Hungary"
		case .india:
			return "India"
		case .indonesia:
			return "Indonesia"
		case .ireland:
			return "Ireland"
		case .israel:
			return "Israel"
		case .italy:
			return "Italy"
		case .japan:
			return "Japan"
		case .latvia:
			return "Latvia"
		case .lithuania:
			return "Lithuania"
		case .malaysia:
			return "Malaysia"
		case .mexico:
			return "Mexico"
		case .morocco:
			return "Morocco"
		case .netherlands:
			return "Netherlands"
		case .newZealand:
			return "New Zealand"
		case .nigeria:
			return "Nigeria"
		case .norway:
			return "Norway"
		case .pakistan:
			return "Pakistan"
		case .philippines:
			return "Philippines"
		case .poland:
			return "Poland"
		case .portugal:
			return "Portugal"
		case .romania:
			return "Romania"
		case .russia:
			return "Russia"
		case .saudiArabia:
			return "Saudi Arabia"
		case .serbia:
			return "Serbia"
		case .singapore:
			return "Singapore"
		case .slovakia:
			return "Slovakia"
		case .slovenia:
			return "Slovenia"
		case .southAfrica:
			return "South Africa"
		case .southKorea:
			return "South Korea"
		case .spain:
			return "Spain"
		case .sweden:
			return "Sweden"
		case .switzerland:
			return "Switzerland"
		case .taiwan:
			return "Taiwan"
		case .thailand:
			return "Thailand"
		case .turkey:
			return "Turkey"
		case .uae:
			return "United Arab Emirates"
		case .ukraine:
			return "Ukraine"
		case .unitedKingdom:
			return "United Kingdom"
		case .unitedStates:
			return "United States"
		case .venuzuela:
			return "Venuzuela"
		}
	}
}

extension Country: Comparable {
	static func < (lhs: Country, rhs: Country) -> Bool {
		lhs.title < rhs.title
	}
}
