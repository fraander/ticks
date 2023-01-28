//
//  ImportanceOptions.swift
//  ImportanceOptions
//
//  Created by Frank on 9/16/21.
//

import SwiftUI
import Foundation

struct ImportanceOptions {
	static let allOptions = [high, medium, low, none]
	
	static let high = "High"
	static let medium = "Medium"
	static let low = "Low"
	static let none = "None"
	
	@ViewBuilder
	static func getIcon(option: String) -> some View {
		switch option {
			case ImportanceOptions.high:
				Image(systemName: "exclamationmark.3")
			case ImportanceOptions.medium:
				Image(systemName: "exclamationmark.2")
			case ImportanceOptions.low:
				Image(systemName: "exclamationmark")
			default:
				Text("None")
		}
	}
	
	static func getIconName(option: String) -> String {
		switch option {
			case ImportanceOptions.high:
				return "exclamationmark.3"
			case ImportanceOptions.medium:
				return "exclamationmark.2"
			case ImportanceOptions.low:
				return "exclamationmark"
			default:
				return "exclamationmark.2"
		}
	}
	
	static func getColor(option: String) -> Color {
		switch option {
			case ImportanceOptions.high:
				return Color.red
			case ImportanceOptions.medium:
				return Color.orange
			case ImportanceOptions.low:
				return Color.yellow
			default:
				return Color.secondary
		}
	}
}
