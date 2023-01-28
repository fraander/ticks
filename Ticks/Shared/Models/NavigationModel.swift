//
//  NavigationModel.swift
//  NavigationModel
//
//  Created by Frank on 9/11/21.
//

import Foundation

class NavigationModel: ObservableObject {
	
	@Published var listSelection: CD_List?
	@Published var taskSelection = Set<CD_Task>()
	@Published var tagSelection: CD_Tag?
	@Published var taskHover: CD_Task?
	@Published var taskDetailSelection: CD_Task?
	
	@Published var showingNewTaskField = false
	@Published var showingNewListField = false
	
	@Published var showingDetailPane = false
		
	@Published var specialList: ListType? = .all
	
	enum ListType {case all, inbox}
}
