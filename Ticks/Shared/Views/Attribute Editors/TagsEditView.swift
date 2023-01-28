//
//  TagsPopover.swift
//  TagsPopover
//
//  Created by Frank on 10/3/21.
//

import SwiftUI

struct TagsEditView: View {
	@FetchRequest(
		entity: CD_Tag.entity(),
		sortDescriptors: [
			NSSortDescriptor(keyPath: \CD_List.title, ascending: true),
			NSSortDescriptor(keyPath: \CD_List.objectID, ascending: true)
		]
	) var tags: FetchedResults<CD_Tag>
	
	@ObservedObject var task: CD_Task
	
	@State var searchText = ""
	
	var filteredTags: [CD_Tag] {
		var output = [CD_Tag]()
		
		if searchText == "" {
			output = tags.sorted(by: {$0._title <= $1._title})
		} else {
			output = tags
				.filter {$0._title.uppercased().contains(searchText.uppercased())}
		}
		
		return output.filter { tag in
			!task._tags.contains(tag)
		}
	}
	
	private enum Field: Int, Hashable{
		case title
	}
	@FocusState private var focusedField: Field?
	
	var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			if (task._tags.count != 0) {
				ScrollView(.horizontal) {
					HStack {
						ForEach(task._tags) { tag in
							HStack(spacing: 3) {
								Text("#\(tag._title)")
								
								Button {
									CoreDataHelper.removeTagFrom(task: task, tag: tag)
								} label: {
									Image(systemName: "xmark.circle")
								}
								.buttonStyle(.plain)
								
							}
							.font(.caption)
							.foregroundColor(.white)
							.padding(3)
							.padding(.horizontal, 3)
							.background(
								Capsule().fill(tag._color)
							)
						}
					}
					.padding([.vertical, .leading], 5)
				}
				
				Divider()
			}
			
			TextField("Search Field", text: $searchText)
				.focused($focusedField, equals: .title)
				.onSubmit {
					if filteredTags.count > 0 {
						commitAction(entry: filteredTags.first?._title ?? "")
					} else {
						commitAction(entry: searchText)
					}
				}
				.padding(5)
			
			Divider()
			
			ScrollView(.vertical) { //-TODO: allow using up and down arrows to change selection
				VStack(spacing: 0) {
					ForEach(filteredTags) {tag in
						Button {
							commitAction(entry: tag._title)
						} label: {
							ZStack {
								filteredTags.first == tag ? Color.accentColor : Color.clear
								
								HStack(spacing: 5) {
									tag._icon
										.padding(.leading, 5)
									
									Text(tag._title)
										.tag(tag)
									
									Spacer()
								}
							}
							.frame(height: 25)
						}
						.buttonStyle(.borderless)
					}
				}
				
			}
			.frame(maxHeight: 120)
			
			if !filteredTags.contains(where: {
				$0._title == searchText
			}) && searchText != "" {
				
				Divider()
				
				Button {
					commitAction(entry: searchText)
				} label: {
					ZStack {
						filteredTags.count == 0 ? Color.accentColor : Color.clear
						
						HStack {
							Image(systemName: "circle.fill").foregroundColor(.secondary)
								.padding(.leading)
							
							Text("Create \(searchText)")
							
							Spacer()
						}
					}
					.frame(height: 25)
				}
				.buttonStyle(.borderless)
			}
		}
		.frame(width: 160)
		.task {
			focusedField = .title
		}
	}
	
	func commitAction(entry: String) {
		guard entry != "" else {return}
		
		if filteredTags.count > 0 {
			if let t = CoreDataHelper.getTagWith(name: entry) {
				task.addToTags(t)
			} else {
				CoreDataHelper.createTag(title: entry)
			}
		} else {
			CoreDataHelper.createTag(title: entry)
		}
		
		searchText = ""
	}
}
