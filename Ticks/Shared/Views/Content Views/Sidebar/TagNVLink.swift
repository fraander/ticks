//
//  TagNVLink.swift
//  TagNVLink
//
//  Created by Frank on 10/11/21.
//

import Foundation
import SwiftUI

struct TagNVLink: View {
	@EnvironmentObject var navigationModel: NavigationModel
	@State var showingTagEditView = false
	
	@ObservedObject var tag: CD_Tag
	
	var body: some View {
		NavigationLink(
			destination: {
				TicksTagView(tag: tag)
					.task {
						navigationModel.tagSelection = tag
					}
					.navigationTitle(tag._title)
#if os(macOS)
					.navigationSubtitle("\(tag._tasksCount) tasks")
				
#endif
			},
			label: {
				HStack {
					tag._icon
					Text("\(tag._title)")
				}
			}
		)
			.popover(isPresented: $showingTagEditView) {
				EditTagView(tag: tag)
			}
			.contextMenu() {
				Button {
					showingTagEditView = true
				} label: {
					Label {
						Text("Edit Tag")
					} icon: {
						Image(systemName: "pencil.and.outline")
					}
				}
				
				Button {
					CoreDataHelper.deleteTag(tag: tag, navigationModel: navigationModel)
				} label: {
					Label {
						Text("Delete Tag")
					} icon: {
						Image(systemName: "trash.fill")
					}
					
				}				
			}
	}
}
