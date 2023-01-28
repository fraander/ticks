//
//  CustomToolbar.swift
//  Ticks
//
//  Created by Frank on 11/12/21.
//

import SwiftUI

struct CustomToolbar: View {
	
	@ObservedObject var task: CD_Task
	
	@State var tagsPopover = false
	@State var repetitionsPopover = false
	@State var importancePopover = false
	@State var datePopover = false
	@State var descriptionPopover = false
	
    var body: some View {
		ZStack {
			HStack {
				Button {
					tagsPopover.toggle()
				} label: {
					Image(systemName: "number")
				}
				.popover(isPresented: $tagsPopover) {
					TagsEditView(task: task)
				}
				
				Button {
					repetitionsPopover.toggle()
				} label: {
					Image(systemName: "arrow.triangle.2.circlepath")
				}
				.popover(isPresented: $repetitionsPopover) {
					RepetitionEditView(task: task)
				}
				
				Button {
					importancePopover.toggle()
				} label: {
					Image(systemName: "exclamationmark.2")
				}
				.popover(isPresented: $importancePopover) {
					ImportanceEditView(task: task)
				}
				
				Button {
					datePopover.toggle()
				} label: {
					Image(systemName: "calendar")
				}
				.popover(isPresented: $datePopover) {
					DateEditView(task: task)
				}
				
				Button {
					descriptionPopover.toggle()
				} label: {
					Image(systemName: "pencil")
				}
				.popover(isPresented: $descriptionPopover) {
					DescriptionEditView(task: task)
				}
			}
			.padding()
			.background(
				Capsule().fill(Color.accentColor)
			)
			.padding(.bottom)
			.shadow(color: .primary.opacity(0.5), radius: 5, x: 0, y: 0)
		}
    }
}

//struct CustomToolbar_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomToolbar()
//    }
//}

struct DescriptionEditView: View {
	@ObservedObject var task: CD_Task
	@State var notes = ""
	@FetchRequest(
		entity: CD_List.entity(),
		sortDescriptors: [
			NSSortDescriptor(keyPath: \CD_List.dateCreated, ascending: true),
			NSSortDescriptor(keyPath: \CD_List.objectID, ascending: true)
		]
	) var lists: FetchedResults<CD_List>
	
	@State var listChoice = "Inbox"
	@EnvironmentObject var navigationModel: NavigationModel
	
	var body: some View {
		VStack(alignment: .leading, spacing: 5) {
			Picker(selection: $listChoice) {
				Text("Inbox")
					.tag("Inbox")
				
				ForEach (lists) { list in
					Text(list._title)
						.tag(list._title)
				}
				
				
			} label: {
				Text("List")
			}
			.task {
				if let l = task.list {
					listChoice = l._title
				} else {
					listChoice = "Inbox"
				}
			}
			.onChange(of: listChoice) { newValue in
				CoreDataHelper.moveTask(to: newValue, task: task, nvm: navigationModel)
			}
			
			Text("Notes")
				.font(.headline)
			TextEditor(text: $notes).frame(width: 200, height: 200)
				.onDisappear {
					task.notes = notes
					let _ = try? CoreDataHelper.saveContext()
				}
		}
	}
}
