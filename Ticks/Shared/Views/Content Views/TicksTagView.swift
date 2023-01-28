//
//  TicksTagView.swift
//  TicksTagView
//
//  Created by Frank on 9/22/21.
//

import SwiftUI

struct TicksTagView: View {
	
	@Environment(\.managedObjectContext) private var moc
	@EnvironmentObject var navigationModel: NavigationModel
	@ObservedObject var tag: CD_Tag
	
    var body: some View {
		List(selection: $navigationModel.taskSelection) {
			TicksTagForEach(tag: tag)
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

struct TicksTagForEach: View {
	
	@EnvironmentObject var navigationModel: NavigationModel
	@Environment(\.managedObjectContext) private var moc
	@ObservedObject var tag: CD_Tag
	
	var body: some View {
		ForEach(tag._tasks) { task in
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
					.tint(tag._color)
				}
				.tag(task)
		}
	}
}

//struct TicksTagView_Previews: PreviewProvider {
//    static var previews: some View {
//        TicksTagView()
//    }
//}
