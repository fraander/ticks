//
//  SidebarSectionHeader.swift
//  SidebarSectionHeader
//
//  Created by Frank on 9/24/21.
//

import SwiftUI

struct SidebarSectionHeader: View {
	var plusAction: () -> Void
	let title: String
	
    var body: some View {
		HStack {
			Text(title).bold()
			Button(action: plusAction) {
				Image(systemName: "plus.circle").font(.headline)
			}
			.buttonStyle(.plain)
			Spacer()
		}
    }
}

struct SidebarSectionHeader_Previews: PreviewProvider {
    static var previews: some View {
		SidebarSectionHeader(plusAction: {print("print")}, title: "Tags")
    }
}
