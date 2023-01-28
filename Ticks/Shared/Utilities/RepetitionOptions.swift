//
//  RepetitionOptions.swift
//  RepetitionOptions
//
//  Created by Frank on 9/16/21.
//

import Foundation
import SwiftUI

struct RepetitionOptions {
	static func getRepetitionFromString(string r: String?) -> RepetitionOption {
		switch r {
			case RepetitionOptions.biweekly.string:
				return RepetitionOptions.biweekly
			case RepetitionOptions.daily.string:
				return RepetitionOptions.daily
			case RepetitionOptions.monthly.string:
				return RepetitionOptions.monthly
			case RepetitionOptions.twiceWeekly.string:
				return RepetitionOptions.twiceWeekly
			case RepetitionOptions.weekly.string:
				return RepetitionOptions.weekly
			case RepetitionOptions.twiceWeekly.string:
				return RepetitionOptions.twiceWeekly
			case RepetitionOptions.none.string:
				return RepetitionOptions.none
			default: //redundant
				return RepetitionOptions.none
		}
	}
	
	static let allOptions = [weekly, daily, monthly, biweekly, twiceWeekly, none]
	
	static let weekly = RepetitionOption("Weekly", .blue)
	static let daily = RepetitionOption("Daily", .blue)
	static let monthly = RepetitionOption("Monthly", .blue)
	static let biweekly = RepetitionOption("Biweekly", .blue)
	static let twiceWeekly = RepetitionOption("Twice Weekly", .blue)
	static let none = RepetitionOption("None", .secondary)
}

struct RepetitionOption: Hashable, Identifiable {
	internal init(_ string: String, _ color: Color) {
		self.string = string
		self.color = color
	}
	
	let id = UUID()
	let string: String
	let color: Color
}
