//
//  ListNVLink.swift
//  ListNVLink
//
//  Created by Frank on 10/10/21.
//

import Foundation
import SwiftUI

struct ListNVLink: View {
	
	@ObservedObject var list: FetchedResults<CD_List>.Element
	@EnvironmentObject var navigationModel: NavigationModel
	@State var showingListEditView = false
	
	var body: some View {
		NavigationLink(
//			tag: list,
//			selection: $navigationModel.listSelection,
			destination: {
				TicksListView(list: list)
					.task {
						navigationModel.listSelection = list
					}
					.navigationTitle(list._title)
#if os(macOS)
					.navigationSubtitle("\(list._tasksCount) tasks")
#endif
			},
			label: {
				HStack {
					list._icon
					Text("\(list._title)")
				}
			}
		)
			.popover(isPresented: $showingListEditView) {
				NewListFieldView(list: list, navigationModel: _navigationModel)
			}
			.contextMenu() {
				Button {
					showingListEditView.toggle()
				} label: {
					Label {
						Text("Edit List")
					} icon: {
						Image(systemName: "pencil.and.outline")
					}
				}
				
				Button {
					CoreDataHelper.deleteList(list: list, navigationModel: navigationModel)
				} label: {
					Label {
						Text("Delete List")
					} icon: {
						Image(systemName: "trash.fill")
					}
					
				}
				
			}
	}
}

//struct <#ViewName#>_Previews: PreviewProvider {
//	static var previews: some View {
//		<#ViewName#>()
//			.preferredColorScheme(.light)
//
//		<#ViewName#>()
//			.preferredColorScheme(.dark)
//	}
//}
