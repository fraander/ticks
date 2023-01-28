//
//  TagsViewIOS.swift
//  Ticks
//
//  Created by Frank on 12/3/21.
//

import SwiftUI

struct TagsViewIOS: View {
	
	@FetchRequest(
		entity: CD_Tag.entity(),
		sortDescriptors: [
			NSSortDescriptor(keyPath: \CD_Tag.title, ascending: true),
			NSSortDescriptor(keyPath: \CD_Tag.objectID, ascending: true)
		]
	) var tags: FetchedResults<CD_Tag>
	
	@ObservedObject var task: CD_Task
	
	var body: some View {
		List(tags) { tag in
			Button {
				withAnimation {
					if (task._tags.contains(tag)) {
						// disconnect tag
						task.removeFromTags(tag)
						let _ = try? CoreDataHelper.saveContext()
					} else {
						// connect tag
						task.addToTags(tag)
						let _ = try? CoreDataHelper.saveContext()
					}					
				}
			} label: {
				HStack {
					Text(tag._title)
					
					Spacer()
					
					Image(systemName: (task._tags.contains(tag) ? "checkmark.circle.fill" : "checkmark.circle"))
				}
			}
		}
		.toolbar {
			Button {
				// trigger popover to add a tag
			} label: {
				Label("Add Tag", systemImage: "plus")
			}

		}
	}
}

//struct TagsViewIOS_Previews: PreviewProvider {
//    static var previews: some View {
//        TagsViewIOS()
//    }
//}
