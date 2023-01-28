//
//  TicksHomeView.swift
//  TicksHomeView
//
//  Created by Frank on 9/11/21.
//

import Foundation
import SwiftUI

struct TicksSidebarView: View {
	//TODO: Navigation just doesn't work on iOS (make it less custom for iOS; eg. rewrite the navigationModel?)
	
	@Environment(\.managedObjectContext) private var moc
	@EnvironmentObject var navigationModel: NavigationModel
	@FetchRequest(
		entity: CD_List.entity(),
		sortDescriptors: [
			NSSortDescriptor(keyPath: \CD_List.dateCreated, ascending: true),
			NSSortDescriptor(keyPath: \CD_List.objectID, ascending: true)
		]
	) var lists: FetchedResults<CD_List>
	
	@FetchRequest(
		entity: CD_Tag.entity(),
		sortDescriptors: [
			NSSortDescriptor(keyPath: \CD_Tag.title, ascending: true),
			NSSortDescriptor(keyPath: \CD_Tag.objectID, ascending: true)
		]
	) var tags: FetchedResults<CD_Tag>
	
	@FetchRequest(
		entity: CD_Task.entity(),
		sortDescriptors: [
			NSSortDescriptor(keyPath: \CD_Task.dateCreated, ascending: true),
			NSSortDescriptor(keyPath: \CD_Task.objectID, ascending: true)
		]
	) var allTasks: FetchedResults<CD_Task>
	
	var inboxTasks: [CD_Task] { allTasks.filter {$0.list == nil} }
	
	@State var searchContent = ""
	var searchResults: [CD_Task] {
		if searchContent.isEmpty {
			return allTasks.sorted(by: {$0._title < $1._title})
		} else {
			return allTasks.filter { $0._title.contains(searchContent) }
		}
	}
	
	var body: some View {
		NavigationView {
			// MARK: -MACOS
#if os(macOS)
			VStack(spacing: 0) {
				List(selection: $navigationModel.listSelection) {
					
					NavigationLink(tag: NavigationModel.ListType.all, selection: $navigationModel.specialList) {
						AllTasksView()
							.navigationTitle("All Tasks")
#if os(macOS)
							.navigationSubtitle("\(allTasks.count) tasks")
#endif
					} label: {
						Label("All Tasks", systemImage: "house")
					}
					
					NavigationLink(tag: NavigationModel.ListType.inbox, selection: $navigationModel.specialList) {
						InboxTasksView()
							.navigationTitle("Inbox")
#if os(macOS)
							.navigationSubtitle("\(inboxTasks.count) tasks")
#endif
					} label: {
						Label("Inbox", systemImage: "envelope")
					}
					
					if tags.count > 0 {
						Section(header: Text("Tags").bold()) {
							ForEach(tags) { tag in
								TagNVLink(tag: tag)
							}
							
						}
					}
					
					if lists.count > 0 {
						Section(header: Text("List").bold()) {
							ForEach(lists) { list in
								
								ListNVLink(list: list)
									.onChange(of: navigationModel.listSelection) { _ in
										if navigationModel.listSelection == nil && navigationModel.tagSelection == nil && navigationModel.specialList == .none {
											navigationModel.specialList = .all
										}
										
										navigationModel.showingDetailPane = false
									}
									.onChange(of: navigationModel.specialList) { _ in
										if navigationModel.listSelection == nil && navigationModel.tagSelection == nil && navigationModel.specialList == .none {
											navigationModel.specialList = .all
										}
										
										navigationModel.showingDetailPane = false
									}
									.onChange(of: navigationModel.tagSelection) { _ in
										if navigationModel.listSelection == nil && navigationModel.tagSelection == nil && navigationModel.specialList == .none {
											navigationModel.specialList = .all
										}
										
										navigationModel.showingDetailPane = false
									}
								
							}
							
						}
					}
					
				}
				
				//				Divider()
				
				ZStack {
					//					Color.secondary
					//						.blur(radius: 20)
					AddListButton()
						.frame(height: 40)
				}
				.frame(maxWidth: .infinity, alignment: .bottom)
			}
			.frame(minWidth: 150, maxWidth: 400)
			.toolbar {
				ToolbarItem(placement: .primaryAction) {
#if os(macOS)
					Button(action: toggleSidebar, label: {
						Image(systemName: "sidebar.left")
					})
#endif
				}
			}
#else
			// MARK: -IOS
			VStack(spacing: 0) {
				List(selection: $navigationModel.listSelection) {
					
					NavigationLink() {
						AllTasksView()
							.navigationTitle("All Tasks")
#if os(macOS)
							.navigationSubtitle("\(allTasks.count) tasks")
#endif
					} label: {
						Label("All Tasks", systemImage: "house")
					}
					
					NavigationLink() {
						InboxTasksView()
							.navigationTitle("Inbox")
#if os(macOS)
							.navigationSubtitle("\(inboxTasks.count) tasks")
#endif
					} label: {
						Label("Inbox", systemImage: "envelope")
					}
					
					if tags.count > 0 {
						Section(header: Text("Tags").bold()) {
							ForEach(tags) { tag in
								TagNVLink(tag: tag)
							}
							
						}
					}
					
					if lists.count > 0 {
						Section(header: Text("List").bold()) {
							ForEach(lists) { list in
								ListNVLink(list: list)
							}
							
						}
					}
					
				}
				.popover(isPresented: $navigationModel.showingNewListField) {
					NewListFieldView(navigationModel: _navigationModel)
				}
				.toolbar {
					Button {
						navigationModel.showingNewListField = true
					} label: {
						Label("Add List", systemImage: "text.badge.plus")
					}
				}
				.navigationTitle("Ticks")
			}
			.frame(minWidth: 150, maxWidth: 400)
#endif
		}
	}
	
	func toggleSidebar() {
#if os(macOS)
		NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
#endif
	}
}

struct AddListButton: View {
	@EnvironmentObject var navigationModel: NavigationModel
	
	var body: some View {
		Button {
			
		} label: {
			HStack {
				Image(systemName: "text.badge.plus")
				Text("Add List")
			}
			.frame(maxWidth: .infinity, maxHeight: 40)
			
		}
		.buttonStyle(.plain)
		.popover(isPresented: $navigationModel.showingNewListField) {
			NewListFieldView(navigationModel: _navigationModel)
		}
	}
}

//struct TicksHomeView_Previews: PreviewProvider {
//	static var previews: some View {
//		TicksHomeView()
//			.preferredColorScheme(.light)
//
//		TicksHomeView()
//			.preferredColorScheme(.dark)
//	}
//}
