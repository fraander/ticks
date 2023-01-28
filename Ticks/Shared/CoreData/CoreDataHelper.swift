//
//  CoreDataHelper.swift
//  CoreDataHelper
//
//  Created by Frank on 9/13/21.
//

import CoreData
import Foundation
import SwiftUI

class CoreDataHelper {
	static private var viewContext = PersistenceController.shared.container.viewContext
	
	/// Only performs a save if there are changes to commit.
	/// - Returns: `true` if a save was needed. Otherwise, `false`.
	@discardableResult public static func saveContext() throws -> Bool {
		guard CoreDataHelper.viewContext.hasChanges else { return false }
		enactSave()
		return true
	}
	
	static func completeTask(task: CD_Task) {
		task.lastCompletion = Date()
		
		let _ = try? saveContext()
	}
	
	static func getTagWith(name: String) -> CD_Tag? {
		do {
			let fetchRequest : NSFetchRequest<CD_Tag> = CD_Tag.fetchRequest()
			fetchRequest.predicate = NSPredicate(format: "title == %@", name)
			let fetchedResults = try viewContext.fetch(fetchRequest)
			if let firstTag = fetchedResults.first {
				return firstTag
			}
		}
		catch {
			print ("fetch tag failed", error)
		}
		
		return nil
	}
	
	static func removeTagFrom(task: CD_Task, tag: CD_Tag) {
		if let _ = task.tags {
			task.removeFromTags(tag)
			let _ = try? CoreDataHelper.saveContext()
		}
	}
	
	static func getListWith(name: String) -> CD_List? {
		do {
			let fetchRequest : NSFetchRequest<CD_List> = CD_List.fetchRequest()
			fetchRequest.predicate = NSPredicate(format: "title == %@", name)
			let fetchedResults = try viewContext.fetch(fetchRequest)
			if let firstList = fetchedResults.first {
				return firstList
			}
		}
		catch {
			print ("fetch tag failed", error)
		}
		return nil
	}
	
	static func moveTask(to list: String, task: CD_Task, nvm: NavigationModel) {
		if list == "Inbox" {
			task.list = nil
		} else {
			if let l = getListWith(name: list) {
				task.list = l
			}
		}
		
		let _ = try? saveContext()
		
		nvm.taskSelection.removeAll()
		
		nvm.taskSelection.insert(task)			
	}
	
	static func enactSave() {
		DispatchQueue.main.async {
			
			do {
				try viewContext.save()
			} catch {
				let error = error as NSError
				fatalError("Unresolved Error: \(error)")
			}
			
		}
		
	}
	
	static func updateList(title: String, list: CD_List) {
		list.title = title;
		let _ = try? saveContext()
	}
	
	static func updateList(color: String, list: CD_List) {
		list.color = color;
		let _ = try? saveContext()
	}
	
	static func updateList(symbol: String, list: CD_List) {
		list.symbol = symbol;
		let _ = try? saveContext()
	}
	
	static func updateTag(color: String, tag: CD_Tag) {
		tag.color = color
		let _ = try? saveContext()
	}
	static func updateTag(title: String, tag: CD_Tag) {
		tag.title = title
		let _ = try? saveContext()
	}
	
	static func updateList(
		title: String,
		color: String,
		symbol: String,
		navigationModel: NavigationModel,
		list: CD_List
	) {
		list.title = title
		list.color = color
		list.symbol = symbol
		
		let _ = try? saveContext()
		
		navigationModel.listSelection = list
	}
	
	static func createList(
		title: String = "New List",
		color: String = ColorOptions.none.string,
		symbol: String = SymbolOptions.strings[0],
		navigationModel: NavigationModel
	) {
		let newList = CD_List(context: viewContext)
		newList.id = UUID()
		newList.dateCreated = Date()
		
		newList.title = title
		newList.color = color
		newList.symbol = symbol
		
		let _ = try? saveContext()
		
		navigationModel.listSelection = newList
	}
	
	static func createTask(
		title: String = "New Task",
		notes: String = "No notes yet.",
		repetition: String = RepetitionOptions.weekly.string,
		lastCompletion: Date = Date(),
		importance: String = ImportanceOptions.none,
		navigationModel: NavigationModel,
		currentList: CD_List?
	) {
		let newTask = CD_Task(context: viewContext)
		newTask.id = UUID()
		newTask.dateCreated = Date()
		
		newTask.title = title
		newTask.notes = notes
		newTask.repetition = repetition
		newTask.lastCompletion = lastCompletion
		newTask.importance = importance
		
		if let c = currentList {
			c.addToTasks(newTask)
		}
		
		let _ = try? saveContext()
		
		navigationModel.taskSelection.removeAll()
		navigationModel.taskSelection.insert(newTask)
	}
	
	static func createTag(
		title: String,
		color: String = ColorOptions.none.string
	) {
		let newTag = CD_Tag(context: viewContext)
		newTag.id = UUID()
		newTag.dateCreated = Date()
		
		newTag.title = title
		newTag.color = color
		
		let _ = try? saveContext()
	}
	
	static func updateMultipleTasks(tasks: Set<CD_Task>) {
		for task in tasks {
			task.title = "Different name"
		}
		
		let _ = try? saveContext()
	}
	
	static func updateSingleTask(task: CD_Task) {
		task.title = "Different name"
		let _ = try? saveContext()
	}
	
	static func deleteMultipleTasks(tasks: Set<CD_Task>) {
		for task in tasks {
			viewContext.delete(task)
		}
		let _ = try? saveContext()
	}
	
	static func deleteSingleTask(task: CD_Task) {
		viewContext.delete(task)
		let _ = try? saveContext()
	}
	
	static func deleteTag(tag: CD_Tag, navigationModel: NavigationModel) {
		navigationModel.tagSelection = nil
		
		viewContext.delete(tag)
		let _ = try? saveContext()
	}
	
	static func deleteList(list: CD_List, navigationModel: NavigationModel) {
		navigationModel.listSelection = nil
		
		for task in navigationModel.taskSelection {
			if list._tasks.contains(task) {
				navigationModel.taskSelection.remove(task)
			}
		}
		
		for task in list._tasks {
			viewContext.delete(task)
		}
		
		viewContext.delete(list)
		let _ = try? saveContext()
	}
	
	static func updateTaskRepetition(task: CD_Task, newValue: String) {
		task.repetition = newValue
		let _ = try? saveContext()
	}
	
	static func updateTaskImportance(task: CD_Task, newValue: String) {
		task.importance = newValue
		let _ = try? saveContext()
	}
	
	static func updateTask(_ task: CD_Task, title: String? = nil, notes: String? = nil) {
		if let t = title {task.title = t}
		if let d = notes {task.notes = d}
		
		let _ = try? saveContext()
	}
}
