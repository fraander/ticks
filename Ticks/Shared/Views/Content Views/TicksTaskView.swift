//
//  TicksTaskView.swift
//  TicksTaskView
//
//  Created by Frank on 9/11/21.
//

import Foundation
import SwiftUI

struct TaskViewContents: View {
	
	@EnvironmentObject var navigationModel: NavigationModel
	@ObservedObject var task: CD_Task
	
	init(_ task: CD_Task) {
		self.task = task
	}
	
	@State var showEditText = false
	@State var editText = ""
	
	private enum Field: Int, Hashable {
		case title
	}
	@FocusState private var focusedField: Field?
	
	@State var animationDistanceValue: CGFloat = 0
	@State var animationOpacityValue: CGFloat = 100
	@State var animationStrikethroughAction = false
	@State var animationStrikethroughOpacity: CGFloat = 0
	
	@State var showEditDate = false
	
	var body: some View {
		VStack {
			HStack(alignment: .center, spacing: 5) {
				
				Button {
					completeTask()
				} label: {
					Image(systemName: "arrow.right")
						.padding(.vertical, 10)
				}
				.foregroundColor(task.list?._color)
				.buttonStyle(.plain)
				.offset(x: animationDistanceValue, y: 0)
				.opacity(animationOpacityValue)
				
				VStack(alignment: .leading, spacing: 0) {
					#if os(macOS)
					TextField(task._title, text: $editText, onCommit: {
						if editText != "" {
							focusedField = .title
						} else {
							CoreDataHelper.updateTask(task, title: editText)
							focusedField = .none
							showEditText = false
						}
					})
						.submitLabel(.done)
						.fixedSize()
						.task {
							focusedField = .none
							editText = task._title
						}
						.overlay {
							HStack {
								Rectangle()
									.fill(Color.secondary)
									.frame(maxWidth: animationStrikethroughAction ? .infinity : 0, maxHeight: 2, alignment: .leading)
								
								Spacer()
							}
						}
					#elseif os(iOS)
					
					Text(task._title)
						.overlay {
							HStack {
								Rectangle()
									.fill(Color.secondary)
									.frame(maxWidth: animationStrikethroughAction ? .infinity : 0, maxHeight: 2, alignment: .leading)
								
								Spacer()
							}
						}
					
					Text(task._relativeDateString)
						.font(.caption)
						.foregroundColor(task.isOverdue ? Color.orange : Color.secondary)
//						.frame(width: 100)
					
					
					
					#endif
				}
				
				Spacer()
				
				//				#if os(macOS)
				//				Button {
				//					showEditDate.toggle()
				//				} label: {
				//					/*
				//					 Text("\(task.daysUntilOverdue ?? 0) days") //TODO: Use this attribute to create a `Upcoming` tab that displays this more prominently. Add this datum to the date-attribute adjuster.
				//					 */
				//
				//					Text(task._relativeDateString)
				//						.foregroundColor(task.isOverdue ? Color.orange : Color.secondary)
				//						.frame(width: 100)
				//				}
				//				.buttonStyle(.plain)
				//				.popover(isPresented: $showEditDate) {
				//					DateEditView(task: task)
				//				}
				//				#else
				
				#if os(macOS)
				Text(task._relativeDateString)
					.foregroundColor(task.isOverdue ? Color.orange : Color.secondary)
					.frame(width: 100)
				#endif
				//				#endif
				
				//#if os(macOS)
				TaskEditButtons(task: task)
				//#endif
			}
			.contextMenu {
				if let h = navigationModel.taskHover {
					if navigationModel.taskSelection.contains(h) {
						Button {
							CoreDataHelper.deleteMultipleTasks(tasks: navigationModel.taskSelection)
						} label: {
							Label("\(navigationModel.taskSelection.count > 1 ? "Delete Tasks" : "Delete Task")", systemImage: "trash.fill")
						}
					} else {
						Button {
							CoreDataHelper.deleteSingleTask(task: task)
						} label: {
							Label("Delete Task", systemImage: "trash.fill")
						}
					}
				}
			}
			.onHover() {bool in
				if bool {
					withAnimation(Animation.easeIn(duration: 0.08)) {
						navigationModel.taskHover = task
					}
				} else {
					withAnimation() {
						navigationModel.taskHover = nil
					}
				}
			}
		}
	}
	
	func completeTask() {
		CoreDataHelper.completeTask(task: task)
		
		//Animation
		withAnimation(Animation.easeInOut(duration: 0.25)) {
			let distValue = CGFloat(7 * task._title.count)
			
			animationDistanceValue = distValue
			animationOpacityValue = 0
			animationStrikethroughAction = true
			animationStrikethroughOpacity = 100
		}
		
		animationDistanceValue = -20
		
		withAnimation(Animation.easeInOut(duration: 0.25).delay(0.5)) {
			animationDistanceValue = 0
			animationOpacityValue = 100
			animationStrikethroughOpacity = 0
		}
		
		withAnimation(Animation.linear(duration: 0.001).delay(0.75)) {
			animationStrikethroughAction = false
		}
	}
}

struct TaskView: View {
	
	@ObservedObject var task: CD_Task
	
	init(_ task: CD_Task) {
		self.task = task
	}
	
	var body: some View {
#if os(macOS)
		TaskViewContents(task)
#else
		NavigationLink {
			iOSAttributeEditor(task: task, originalTitle: task._title, originalNotes: task._notes, originalCompletion: task.lastCompletion ?? Date(), originalTags: task._tags, originalRepetition: task._repetition, originalImportance: task._importance)
		} label: {
			TaskViewContents(task)
		}
#endif
		
	}
	
	
}

struct TaskEditButtons: View {
	@ObservedObject var task: CD_Task
	
	@State var tagsPopover = false
	@State var repetitionsPopover = false
	@State var importancePopover = false
	@State var descriptionPopover = false
	
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
		ForEach(task._tags) { tag in
			Text("#\(tag._title)")
				.font(.caption)
				.foregroundColor(.white)
				.padding(3)
				.padding(.horizontal, 3)
				.background(
					Capsule().fill(tag._color)
				)
		}
		
		Text("\(Image(systemName: "arrow.triangle.2.circlepath"))\(task._repetition)")
			.font(.caption)
			.foregroundColor(.white)
			.padding(3)
			.padding(.horizontal, 3)
			.background(
				Capsule().fill(ColorOptions.getColorFromString(string: task._repetition).color)
			)
		
		if task._importance != ImportanceOptions.none {
			Text("\(Image(systemName: "\(ImportanceOptions.getIconName(option: task._importance))")) \(task._importance)")
				.font(.caption)
				.foregroundColor(.white)
				.padding(3)
				.padding(.horizontal, 3)
				.background(
					Capsule().fill(ImportanceOptions.getColor(option: task._importance))
				)
		}
	}
}

extension View {
	func taskEditButton(size: Image.Scale = .small, color: Color = .white, padding: CGFloat = 4) -> some View {
		self
			.imageScale(size)
			.foregroundColor(color)
			.padding(padding)
			.background(
				Circle()
					.fill(Color.secondary)
			)
	}
}
