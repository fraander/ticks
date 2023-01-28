//
//  EditTagView.swift
//  EditTagView
//
//  Created by Frank on 10/11/21.
//

import Foundation
import SwiftUI

struct EditTagView: View {
	
	var tag: CD_Tag
	
	@State var title: String = ""
	@State var color: String = ""
	
	var body: some View {
		VStack {
			ColorPicker(newColor: $color)
			
			TextField("Tag", text: $title)
				.onSubmit {
					CoreDataHelper.updateTag(title: title, tag: tag)
				}
		}
		.padding()
		.frame(width: 200)
		.task {
			title = tag._title
			color = tag._colorTitle
		}
//		.onChange(of: title) { newValue in
//			CoreDataHelper.updateTag(title: title, tag: tag)
//		}
		.onChange(of: color) { newValue in
			CoreDataHelper.updateTag(color: color, tag: tag)
		}
	}
}

//struct EditTagView_Previews: PreviewProvider {
//	static var previews: some View {
//		EditTagView()
//			.preferredColorScheme(.light)
//
//		EditTagView()
//			.preferredColorScheme(.dark)
//	}
//}
