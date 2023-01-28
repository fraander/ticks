//
//  ListEditView.swift
//  ListEditView
//
//  Created by Frank on 10/3/21.
//

import SwiftUI

struct ListEditView: View {
	@FetchRequest(
		entity: CD_List.entity(),
		sortDescriptors: [
			NSSortDescriptor(keyPath: \CD_List.title, ascending: true),
			NSSortDescriptor(keyPath: \CD_List.objectID, ascending: true)
		]
	) var lists: FetchedResults<CD_List>
	
	@ObservedObject var newTaskFieldModel: NewTaskFieldModel
	@State var searchText = ""
	
	var filteredLists: [CD_List] {
		if searchText == "" {
			return lists.sorted(by: {$0._title <= $1._title})
		} else {
			let l = lists.filter {$0._title.uppercased().contains(searchText.uppercased())}
			
			return l
		}
		
	}
	
	private enum Field: Int, Hashable{
		case title
	}
	
	@FocusState private var focusedField: Field?
	
	var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			TextField("Search Field", text: $searchText)
				.padding()
				.focused($focusedField, equals: .title)
				.onSubmit {
					commitAction(entry: filteredLists.first?._title ?? "")
				}
			
			Divider()
			
			ForEach(filteredLists) {list in
				Button {
					commitAction(entry: list._title)
				} label: {
					ZStack {
						filteredLists.first == list ? Color.accentColor : Color.clear
						
						HStack {
							list._icon
								.padding(.leading)
							
							Text(list._title)
								.tag(list)
							
							Spacer()
						}
					}
					.frame(height: 30)
				}
				.buttonStyle(.borderless)
			}
		}
		.padding(.bottom)
		.task {
			focusedField = .title
		}
	}
	
	func commitAction(entry: String) {
		if filteredLists.count > 0 {
			newTaskFieldModel.newTitle.append("\(entry)")
			newTaskFieldModel.newTitle.removeAll(where: {$0 == "@"})
			searchText = ""
			newTaskFieldModel.listPopover = false
		}
	}
}
