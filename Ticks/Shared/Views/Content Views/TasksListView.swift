//
//  TasksListView.swift
//  TasksListView
//
//  Created by Frank on 9/11/21.
//

import SwiftUI

struct TicksListView: View {
	
	@Environment(\.managedObjectContext) private var moc
	@EnvironmentObject var navigationModel: NavigationModel
	@ObservedObject var list: CD_List
	
	var body: some View {
		List(selection: $navigationModel.taskSelection) {
			TicksListForEach(list: list)
		}
		.toolbar {
#if os(macOS)
			ToolbarItem(placement: .status) {
				Button {
					navigationModel.showingNewTaskField = true
				} label: {
					Image(systemName: "plus")
				}
				.popover(isPresented: $navigationModel.showingNewTaskField) {
					NewTaskFieldView(navigationModel: navigationModel)
						.frame(width: 250)
				}
				
			}
#else
			ToolbarItem(placement: .navigationBarTrailing) {
				Button {
					navigationModel.showingNewTaskField = true
				} label: {
					Image(systemName: "plus")
				}
				.popover(isPresented: $navigationModel.showingNewTaskField) {
					NewTaskFieldView(navigationModel: navigationModel)
						.frame(width: 250)
				}
				
			}
#endif
		}
	}
}

struct TicksListForEach: View {
	
	@Environment(\.managedObjectContext) private var moc
	@ObservedObject var list: CD_List
	
	var body: some View {
		ForEach(list._tasks) { task in
			TaskView(task)
				.swipeActions(edge: .trailing) {
					Button(role: .destructive) {
						CoreDataHelper.deleteSingleTask(task: task)
					} label: {
						Label("Delete", systemImage: "trash")
					}
				}
				.swipeActions(edge: .leading) {
					Button {
						CoreDataHelper.completeTask(task: task)
					} label: {
						Label("Complete", systemImage: "arrow.right")
					}
					.tint(list._color)
				}
				.tag(task)
		}
	}
}


//struct TicksListView_Previews: PreviewProvider {
//	static var previews: some View {
//		TicksListView(list: List())
//	}
//}
