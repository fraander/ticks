//
//  ImportanceEditView.swift
//  ImportanceEditView
//
//  Created by Frank on 9/16/21.
//

import Foundation
import SwiftUI

struct ImportanceEditView: View {
	@State var choice: String = ImportanceOptions.none
	
	@ObservedObject var task: CD_Task
	@EnvironmentObject var navigationModel: NavigationModel
	
//	init(id objectID: NSManagedObjectID, in context: NSManagedObjectContext) {
//		if let t = try? context.existingObject(with: objectID) as? CD_Task {
//			self.task = t
//		} else {
//			// if there is no object with that id, create new one
//			self.task = CD_Task(context: context)
//			try? context.save()
//		}
//	}
	
	var body: some View {
		Picker("Importance", selection: $choice) {
			ForEach(ImportanceOptions.allOptions, id: \.self) { string in
				ImportanceOptions.getIcon(option: string)
			}
		}
		.pickerStyle(.segmented)
		.labelsHidden()
		.task {
			if task._importance == "" {
				task.importance = ImportanceOptions.none
				let _ = try? CoreDataHelper.saveContext()
			}
			
			choice = task._importance
		}
		.onChange(of: choice) { newValue in
			CoreDataHelper.updateTaskImportance(task: task, newValue: newValue)
		}
		.padding(5)
	}
}
