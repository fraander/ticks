//
//  RepetitionEditView.swift
//  RepetitionEditView
//
//  Created by Frank on 9/16/21.
//

import Foundation
import SwiftUI

struct RepetitionEditView: View {
	@State var choice: RepetitionOption = RepetitionOptions.none
	@State var hovered: RepetitionOption?
	
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
		Picker("Repetition", selection: $choice) {
			ForEach(RepetitionOptions.allOptions, id: \.self) {
				Text($0.string)
			}
		}
		.labelsHidden()
		.task {
			choice = RepetitionOptions.getRepetitionFromString(string: task._repetition)
		}
		.onChange(of: choice) { newValue in
			CoreDataHelper.updateTaskRepetition(task: task, newValue: newValue.string)
		}
		.padding(5)
	}
}
