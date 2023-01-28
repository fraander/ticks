//
//  ListEditView.swift
//  ListEditView
//
//  Created by Frank on 10/3/21.
//

import SwiftUI

struct DateEditView: View {
	
	@ObservedObject var task: CD_Task
	
	private enum Field: Int, Hashable{
		case field, graphical
	}
	
	@FocusState private var focusedField: Field?
	
	var body: some View {
		VStack(alignment: .leading, spacing: 10) {
//			DatePicker(
//				"Date Last Completed",
//				selection: $task._lastCompletion,
//				displayedComponents: [.date]
//			)
//				.datePickerStyle(.graphical)
//				.labelsHidden()
//				.focused($focusedField, equals: .graphical)
			
			DatePicker(
				"Date Last Completed",
				selection: $task._lastCompletion,
				displayedComponents: [.date]
			)
#if os(macOS)
				.datePickerStyle(.field)
			#endif
				.labelsHidden()
				.focused($focusedField, equals: .field)
		}
		.task {
			focusedField = .field
		}
		.padding(5)
	}
}
