//
//  ContentView.swift
//  Shared
//
//  Created by Frank on 9/9/21.
//

import SwiftUI

struct ContentView: View {
	
	@Environment(\.managedObjectContext) private var moc
	@EnvironmentObject var navigationModel: NavigationModel
	
	var body: some View {
		HStack(spacing: 0) {
			TicksSidebarView() //Sidebar + NavLinks for current list
		}
		
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
