//
//  TicksApp.swift
//  Shared
//
//  Created by Frank on 9/9/21.
//

import SwiftUI

// TODO: `Overdue` tab to show tasks that are soonest to be overdue

// TODO: Add notifications for Overdue tasks

// TODO: Display which iCloud account the user is logged in using. (Can't do this, so display a unique user token that is created for them and stored in the CD array. Eg. make a user account that can't actually be used for anything.)
	// TODO: Long-term: Move the entire sync system to CloudKit with specific CloudKit calls so that you can also use the web.

// TODO: Add drag-and-drop for moving tasks between lists
// TODO: Add an Index system to allow the user to re-order the lists.

// TODO: Show x hours ago until 24 hours have passed. 0 days ago looks icky. Less than 1 hour ago should say now. 
// TODO: Some of the date compare seems of by a day or so

// TODO: Make the completions a CoreData entity so that you can see past completions and other data points (avg. time between, etc.)

// TODO: It's kinda slow atm :(
	// Self._printChanges will be your friend for figuring out why/how

@main
struct TicksApp: App {
	
	let persistenceController = PersistenceController.shared
	
	@State var userSymbol: String = ""
	@State var userColor: String = ""
	
    var body: some Scene {
        WindowGroup {
			#if os(macOS)
            MacWindowView()
				.environment(\.managedObjectContext, persistenceController.container.viewContext)
			#else
			iOSWindowView()
				.environment(\.managedObjectContext, persistenceController.container.viewContext)
			#endif
		}
    }
}
