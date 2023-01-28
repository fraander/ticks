//
//  WindowView.swift
//  WindowView
//
//  Created by Frank on 9/12/21.
//

import SwiftUI

struct MacWindowView: View {
	
	@StateObject var navigationModel = NavigationModel()
	
    var body: some View {
        ContentView()
			.environmentObject(navigationModel)
    }
}

struct WindowView_Previews: PreviewProvider {
    static var previews: some View {
        MacWindowView()
    }
}
