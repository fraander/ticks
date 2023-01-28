//
//  InboxTasksView.swift
//  InboxTasksView
//
//  Created by Frank on 9/17/21.
//

import SwiftUI

struct InboxTasksView: View {
	@EnvironmentObject var navigationModel: NavigationModel
	
	
    var body: some View {
		List(selection: $navigationModel.taskSelection) {
			InboxForEach()
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

struct InboxForEach: View {
	
	@Environment(\.managedObjectContext) private var moc
	@FetchRequest(
		entity: CD_Task.entity(),
		sortDescriptors: [
			NSSortDescriptor(keyPath: \CD_Task.dateCreated, ascending: true),
			NSSortDescriptor(keyPath: \CD_Task.objectID, ascending: true)
		],
		predicate: NSPredicate(format: "list == nil")
	) var tasks: FetchedResults<CD_Task>
	
	var body: some View {
		ForEach(tasks, id: \.objectID) { task in
			TaskView(task)
				.swipeActions(edge: .trailing) {
					Button(role: .destructive) {
						withAnimation {
							CoreDataHelper.deleteSingleTask(task: task)							
						}
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
					.tint(.accentColor)
				}
				.tag(task)
		}
	}
}

struct AllTasksInboxWrapper: View {
	@Environment(\.managedObjectContext) private var moc
	@State var listUnfolded = true
	var rotationAngle: Angle {
		listUnfolded ? .zero : .degrees(90)
	}
	
	@FetchRequest(
		entity: CD_Task.entity(),
		sortDescriptors: [
			NSSortDescriptor(keyPath: \CD_Task.dateCreated, ascending: true),
			NSSortDescriptor(keyPath: \CD_Task.objectID, ascending: true)
		],
		predicate: NSPredicate(format: "list == nil")
	) var tasks: FetchedResults<CD_Task>
	
	var body: some View {
		if tasks.count > 0 {
			Group {
				#if os(macOS)
				HStack {
					ColorOptions.getIcon(symbol: "folder.fill", color: "none")
					
					
					Text("Inbox")
						.font(.headline)
					
					VStack {
						Divider()
					}
					
					Text( "\(tasks.count) tasks" )
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
					InboxForEach()
				}
				#else
				Section(header: Text("Inbox")) {
					InboxForEach()					
				}
				#endif
			}
		} else {
			EmptyView()
		}
	}
}

struct InboxTasksView_Previews: PreviewProvider {
    static var previews: some View {
        InboxTasksView()
    }
}
