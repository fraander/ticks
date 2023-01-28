//
//  iOSWindowView.swift
//  iOSWindowView
//
//  Created by Frank on 10/13/21.
//

import SwiftUI

struct iOSWindowView: View {
	@StateObject var navigationModel = NavigationModel()
	@Environment(\.managedObjectContext) private var moc
	
    var body: some View {
        TicksSidebarView()
			.environmentObject(navigationModel)
    }
}
