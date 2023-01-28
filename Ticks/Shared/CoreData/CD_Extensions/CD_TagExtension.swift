//
//  CD_TagExtension.swift
//  CD_TagExtension
//
//  Created by Frank on 9/16/21.
//

import Foundation
import SwiftUI

extension CD_Tag {
	
	var _color: Color {
		get {
			return ColorOptions.getColorFromString(string: color).color
		}
	}
	
	var _colorTitle: String {
		get {
			return color ?? ""
		}
		set {
			color = newValue
		}
	}
	
	var _title: String {
		get {
			return title ?? ""
		}
		set {
			title = newValue
		}
	}
	
	var _icon: some View {
		return Image(systemName: "circle.fill").foregroundColor(_color)
	}
	
	var _tasksCount: Int {
		return tasks?.count ?? 0
	}
	
	var _tasks: [CD_Task] {
		if let tasksArray = tasks?.sortedArray(
			using: [
				NSSortDescriptor(keyPath: \CD_Task.objectID, ascending: true)
			]
		) as? [CD_Task] {
			return tasksArray
		}
		
		return [CD_Task()]
	}
}
