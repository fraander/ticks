//
//  NewTaskField.swift
//  NewTaskField
//
//  Created by Frank on 9/9/21.
//

import Combine
import Foundation
import SwiftUI

struct NewTaskFieldView: View {
	@ObservedObject var newTaskFieldModel: NewTaskFieldModel
	
	@EnvironmentObject var navigationModel: NavigationModel
	
	init(navigationModel: NavigationModel) {
		self.newTaskFieldModel = NewTaskFieldModel(navigationModel: navigationModel)
	}
	
	var body: some View {
		VStack {
			VStack(spacing: 10) {
				TextField("New task", text: $newTaskFieldModel.newTitle)
					.onSubmit {
						CoreDataHelper.createTask(title: newTaskFieldModel.newTitle, navigationModel: navigationModel, currentList: navigationModel.listSelection)
					}
//					.onChange(of: newTaskFieldModel.newTitle) { newValue in
//						if newValue.contains("@") {
//							newTaskFieldModel.listPopover = true
//						} else if newValue.contains("#") {
//							newTaskFieldModel.tagPopover = true
//						} else if newValue.contains("$") {
//							newTaskFieldModel.repetitionPopover = true
//						} else if newValue.contains("!") {
//							newTaskFieldModel.importancePopover = true
//						}
//					}
//					.popover(isPresented: $newTaskFieldModel.listPopover) {ListEditView(newTaskFieldModel: newTaskFieldModel)}
//					.popover(isPresented: $newTaskFieldModel.tagPopover) {TagsEditView(newTaskFieldModel: newTaskFieldModel)}
//					.popover(isPresented: $newTaskFieldModel.repetitionPopover) {RepetitionEditView(newTaskFieldModel: newTaskFieldModel)}
//					.popover(isPresented: $newTaskFieldModel.importancePopover) {ImportanceEditView(newTaskFieldModel: newTaskFieldModel)}

				
			}
			.frame(maxWidth: 200)
		}
		.padding()
	}
}

class NewTaskFieldModel: ObservableObject {
	
	@ObservedObject var navigationModel: NavigationModel
	
	@Published var newTitle: String = ""
	@Published var newNotes = ""
	@Published var newList = ""
	@Published var newTags = [CD_Tag]()
	@Published var newRepetition = ""
	@Published var newImportance = ""
	
	@Published var listPopover = false
	@Published var tagPopover = false
	@Published var repetitionPopover = false
	@Published var importancePopover = false

	func createTask() {
		
		if newTitle != "" {
			CoreDataHelper.createTask(
				title: newTitle,
				notes: newNotes,
				repetition: newRepetition,
				lastCompletion: Date().addingTimeInterval(-15000000),
				importance: newImportance,
				navigationModel: navigationModel,
				currentList: navigationModel.listSelection
			)
			
			newTitle = ""
			
			navigationModel.showingNewTaskField = false
			
		}
	}

	init(navigationModel: NavigationModel) {
		
		self.navigationModel = navigationModel
		
	}
}

//struct NewTaskFieldView_Previews: PreviewProvider {
//	static var previews: some View {
//		NewTaskFieldView()
//	}
//}
