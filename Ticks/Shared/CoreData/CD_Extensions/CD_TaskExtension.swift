//
//  CD_TaskExtension.swift
//  CD_TaskExtension
//
//  Created by Frank on 9/16/21.
//

import Foundation
import SwiftUI

extension CD_Task {
	
	var _title: String {
		get {
			return title ?? ""
		}
		set {
			title = newValue
		}
	}
	
	var _notes: String {
		get {
			return notes ?? ""
		}
		set {
			notes = newValue
		}
	}
	
	var _lastCompletion: Date {
		get {
			return lastCompletion ?? Date()
		}
		
		set(newValue) {
			lastCompletion = newValue
		}
	}
	
	var _importance: String {
		get {
			return importance ?? ""
		}
		set {
			importance = newValue
		}
	}
	
	var _repetition: String {
		get {
			return repetition ?? ""
		}
		set {
			repetition = newValue
		}
	}
	
	var _tags: [CD_Tag] {
		if let tagsArray = tags?.sortedArray(
			using: [
				NSSortDescriptor(keyPath: \CD_Tag.objectID, ascending: true)
			]
		) as? [CD_Tag] {
			return tagsArray
		}
		
		return [CD_Tag()]
	}
	
	@ViewBuilder
	var importanceSymbol: some View {
		ImportanceOptions.getIcon(option: _importance)
	}
	
	var importanceColor: Color {
		switch _importance {
			case "High":
				return Color.red
			case "Medium":
				return Color.orange
			case "Low":
				return Color.yellow
			default:
				return Color.secondary
		}
	}
	
	var repetitionSymbol: some View {
		let rObj = RepetitionOptions.getRepetitionFromString(string: repetition)
		
		return Text(rObj.string)//.foregroundColor(.white).padding(5).background(RoundedRectangle(cornerRadius: 5).fill(rObj.color))
	}
	
	var _tagIcons: some View {
		ScrollView(.horizontal) {
			ForEach(_tags) { tag in
				Text(tag._title).font(.caption)
					.padding(3)
					.background(
						RoundedRectangle(cornerRadius: 5.0)
							.fill(tag._color)
					)
			}
		}
	}
	
	var _relativeDate: Int {
		guard lastCompletion != nil else { return 0 }
		
		//https://www.dvhu.com/ask/60579264/Check-if-specific-date-isToday-or-passed-Swift.html
//		if date >= Calendar.current.dateWith(year: Date()., month: 3, day: 28) ?? Date.distantFuture {
//			return true
//		} else {
//			return false
//		}
		let calendar = Calendar.current
		
		let _lastCompletion: Date = calendar.startOfDay(for: lastCompletion ?? Date()) //get lastCompletion date in a safe way
		
		///https://www.hackingwithswift.com/example-code/language/how-to-check-whether-a-date-is-inside-a-date-range
		let now = calendar.startOfDay(for: Date())
		let hourAgo = calendar.startOfDay(for: Date() - 60 * 60)
		
//		let monthAgo = calendar.date(byAdding: .month, value: -1, to: now)
		
		let hourRange = hourAgo...now
//		let monthRange = (monthAgo ?? Date())...now
		
		if hourRange.contains(_lastCompletion) { //if the completion is within the last hour
			return(0)
		//} else if !monthRange.contains(_lastCompletion) { // check on the last 6 months
			//let formatter = DateFormatter()
			//formatter.timeStyle = .none
			//formatter.dateStyle = .medium
			
			//return formatter.string(from: _lastCompletion)
		} else { //finally do relative time
			///https://sarunw.com/posts/getting-number-of-days-between-two-dates/
			let numberOfDays = numberOfDaysSince(now: now, before: _lastCompletion, calendar: calendar) // <3>
			
			return numberOfDays ?? 0
		}
	}
	
	var _relativeDateString: String {
		
		return "\(_relativeDate /*?? 0*/) \(_relativeDate == 1 ? "day" : "days") ago"
	}
	
	func numberOfDaysSince(now: Date, before: Date, calendar: Calendar) -> Int? {
		return calendar.dateComponents([.day], from: calendar.startOfDay(for: before), to: calendar.startOfDay(for: now)).day // <3>
	}
	
	var daysUntilOverdue: Int? {
		// get repetition method
		let r = RepetitionOptions.getRepetitionFromString(string: _repetition)
		
		// convert method to date components
		// compare time using date components
		let calendar = Calendar.current
		let now = calendar.startOfDay(for: Date())
		
		var newDate: Date?
		
		switch r {
				
			case RepetitionOptions.daily:
				// 1 day
				var dateComponent = DateComponents()
				dateComponent.day = -1
				
				newDate = Calendar.current.date(byAdding: dateComponent, to: now)
				
			case RepetitionOptions.twiceWeekly:
				// 4 days
				var dateComponent = DateComponents()
				dateComponent.day = -4
				
				newDate = Calendar.current.date(byAdding: dateComponent, to: now)
				
			case RepetitionOptions.weekly:
				// 7 days
				var dateComponent = DateComponents()
				dateComponent.day = -7
				
				newDate = Calendar.current.date(byAdding: dateComponent, to: now)
				
			case RepetitionOptions.biweekly:
				// 14 days
				var dateComponent = DateComponents()
				dateComponent.day = -14
				
				newDate = Calendar.current.date(byAdding: dateComponent, to: now)
				
			case RepetitionOptions.monthly:
				// 1 month
				var dateComponent = DateComponents()
				dateComponent.month = -1
				
				newDate = Calendar.current.date(byAdding: dateComponent, to: now)
				
			default:
				return nil;
		}
		
		let timeSinceRepetition = numberOfDaysSince(now: now, before: newDate ?? Date(), calendar: calendar)
		let timeSinceLastCompletion = numberOfDaysSince(now: now, before: _lastCompletion, calendar: calendar)
		
		return (timeSinceRepetition ?? 0) - (timeSinceLastCompletion ?? 0)
	}
	
	var isOverdue: Bool {
		// get repetition method
		
		let r = RepetitionOptions.getRepetitionFromString(string: _repetition)
		
		// convert method to date components
		// compare time using date components
		let calendar = Calendar.current
		let now = calendar.startOfDay(for: Date())

		var newDate: Date?
		
		switch r {
				
			case RepetitionOptions.daily:
				// 1 day
				var dateComponent = DateComponents()
				dateComponent.day = -1
				
				newDate = Calendar.current.date(byAdding: dateComponent, to: now)
				
			case RepetitionOptions.twiceWeekly:
				// 4 days
				var dateComponent = DateComponents()
				dateComponent.day = -4
				
				newDate = Calendar.current.date(byAdding: dateComponent, to: now)
				
			case RepetitionOptions.weekly:
				// 7 days
				var dateComponent = DateComponents()
				dateComponent.day = -7
				
				newDate = Calendar.current.date(byAdding: dateComponent, to: now)

			case RepetitionOptions.biweekly:
				// 14 days
				var dateComponent = DateComponents()
				dateComponent.day = -14
				
				newDate = Calendar.current.date(byAdding: dateComponent, to: now)

			case RepetitionOptions.monthly:
				// 1 month
				var dateComponent = DateComponents()
				dateComponent.month = -1
				
				newDate = Calendar.current.date(byAdding: dateComponent, to: now)

			default:
				return false;
		}
		
		let timeSinceRepetition = numberOfDaysSince(now: now, before: newDate ?? Date(), calendar: calendar)
		let timeSinceLastCompletion = numberOfDaysSince(now: now, before: _lastCompletion, calendar: calendar)
		
		if timeSinceRepetition ?? 0 > timeSinceLastCompletion ?? 0 {
			return false
		} else {
			return true
		}
	}
}

extension String {
	func capitalFirst() -> String {
		return prefix(1).capitalized + dropFirst()
	}
	
	mutating func capitalizeFirstLetter() {
		self = self.capitalFirst()
	}
}
