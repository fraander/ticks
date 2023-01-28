//
//  CD_Extensions.swift
//  CD_Extensions
//
//  Created by Frank on 9/13/21.
//

import Foundation
import SwiftUI

extension CD_List {
	
	var _color: Color {
		return ColorOptions.getColorFromString(string: color).color
	}
	
	var _icon: some View {
		return ColorOptions.getIcon(symbol: symbol, color: color)
		
	}
	
	var _title: String {
		return title ?? ""
	}
	
	var _tasksCount: Int {
		return tasks?.count ?? 0
	}
	
	var _symbol: String {
		symbol ?? "folder.fill"
	}
	
	var _colorName: String {
		return color ?? ""
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
