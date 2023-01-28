//
//  iOSAttributeEditor.swift
//  iOSAttributeEditor
//
//  Created by Frank on 10/13/21.
//

struct ListPickerViewIOS: View {
	@ObservedObject var task: CD_Task
	
	var body: some View {
		Group {
			Text("")
		}
	}
}

import SwiftUI

struct iOSAttributeEditor: View {
	
	@ObservedObject var task: CD_Task
	@Environment(\.presentationMode) private var presentationMode
	
	@State var originalTitle: String
	@State var originalNotes: String
	@State var originalCompletion: Date
	@State var originalTags: [CD_Tag]
	@State var originalRepetition: String
	@State var originalImportance: String
	@State var originalList: CD_List?

	
    var body: some View {
		Form {
			Section {
				TextField("Title", text: $task._title)
					.onChange(of: task._title) { newValue in
						let _ = try? CoreDataHelper.saveContext()
					}
			}
			
			Section {
				
				NavigationLink("List") { // TODO: Create a proper List picker view a-la TagsViewIOS
					ListPickerViewIOS(task: task) // Page-based "picker" (NV to tags page)
				}
				
				NavigationLink("Tags") { // TODO: Create a proper TagsViewIOS
					TagsViewIOS(task: task)
					// TODO: Show the selected tags in a cool way
				}
				
				Picker("Repetition", selection: $task._repetition) {
					ForEach(RepetitionOptions.allOptions, id: \.string) { option in
						Text(option.string)
					}
				}
				.onChange(of: task._repetition) { newValue in
					let _ = try? CoreDataHelper.saveContext()
				}
				
				Picker("Importance", selection: $task._importance) {
					ForEach(ImportanceOptions.allOptions, id: \.self) { option in
						ImportanceOptions.getIcon(option: option)
					}
				}
				.pickerStyle(.segmented)
				.onChange(of: task._importance) { newValue in
					let _ = try? CoreDataHelper.saveContext()
				}
			}
			
			Section("Last Completion") {
				DatePicker("Last Completion", selection: $task._lastCompletion, displayedComponents: [.date])
					.datePickerStyle(.graphical)
					.onChange(of: task._lastCompletion) { newValue in
						let _ = try? CoreDataHelper.saveContext()
					}
			}
			
			Section("Notes") {
				ZStack {
					TextEditor (text: $task._notes)
					Text(task._notes)
						.opacity (0)
						.padding( .all, 8)
				}
				.onChange(of: task._notes) { newValue in
					let _ = try? CoreDataHelper.saveContext()
				}
			}
		}
//		.navigationTitle("\(task._title)") // Update based on Title changing
		.toolbar {
			Button("Cancel") {
				task._title = originalTitle
				task._notes = originalNotes
				task._lastCompletion = originalCompletion
				task.tags = Set(originalTags) as NSSet
				task.repetition = originalRepetition
				task.importance = originalImportance
				task.list = originalList
				
				let _ = try? CoreDataHelper.saveContext()
				
				presentationMode.wrappedValue.dismiss()
			}
		}
		.task {
			originalTitle = task._title
			originalNotes = task._notes
			originalCompletion = task._lastCompletion
			originalTags = task._tags
			originalRepetition = task._repetition
			originalImportance = task._importance
			originalList = task.list
		}
    }
}

//struct iOSAttributeEditor_Previews: PreviewProvider {
//    static var previews: some View {
//		NavigationView {
//			iOSAttributeEditor()
//		}
//    }
//}
