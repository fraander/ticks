//
//  AllTasksView.swift
//  AllTasksView
//
//  Created by Frank on 9/12/21.
//

import Foundation
import SwiftUI

struct AllTasksView: View {
	
	// TODO: If a list contains the selected task when it gets folded, deselect the task.
	
	@Environment(\.managedObjectContext) private var moc
	@EnvironmentObject var navigationModel: NavigationModel
	@FetchRequest(
		entity: CD_List.entity(),
		sortDescriptors: [
			NSSortDescriptor(keyPath: \CD_List.dateCreated, ascending: true),
			NSSortDescriptor(keyPath: \CD_List.objectID, ascending: true)
		]
	) var lists: FetchedResults<CD_List>
	
	var body: some View {
		ZStack {
			
			List(selection: $navigationModel.taskSelection) {
				
				AllTasksInboxWrapper()
				
				ForEach(lists) { list in
					if list._tasksCount > 0 {
						TicksListWithHeaderView(list: list)
					}
				}
			}
			
			if navigationModel.taskSelection.count == 1 {
				CustomToolbar(task: navigationModel.taskSelection.first!)
					.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
			}
		}
		.toolbar {
#if os(macOS)
            ToolbarItem(placement: .primaryActionv
            ) {
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

struct AllTasksView_Previews: PreviewProvider {
	static var previews: some View {
		AllTasksView()
	}
}

struct TicksListWithHeaderView: View {
	@EnvironmentObject var navigationModel: NavigationModel
	@Environment(\.managedObjectContext) private var moc
	@ObservedObject var list: CD_List
	
	@State var listUnfolded = true
	var rotationAngle: Angle {
		listUnfolded ? .zero : .degrees(90)
	}
	
	var body: some View {
		Group {
#if os(macOS)
			HStack {
				list._icon
				
				
				Text(list._title)
					.font(.headline)
				
				VStack {
					Divider()
				}
				
				Text( "\(list._tasks.count) tasks" )
					.font(.subheadline)
				
				Image(systemName: "chevron.down")
					.rotationEffect(rotationAngle)
			}
			.onTapGesture {
				withAnimation {
					listUnfolded.toggle()
				}
			}
			
			if listUnfolded {
				TicksListForEach(list: list)
			}
#else
			Section(header: Text("\(list._title)")) {
				TicksListForEach(list: list)
			}
#endif
		}
		.onChange(of: listUnfolded) { _ in
			for t in navigationModel.taskSelection {
				if list._tasks.contains(t) {
					navigationModel.taskSelection.remove(t)
				}
			}
		}
	}
}

//struct TicksListWithHeaderView_Previews: PreviewProvider {
//	static var previews: some View {
//		TicksListWithHeaderView(list: .constant( TicksList(title: "Inbox") ) )
//			.preferredColorScheme(.light)
//	}
//}
