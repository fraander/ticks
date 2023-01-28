//
//  NewListField.swift
//  NewListField
//
//  Created by Frank on 9/12/21.
//

import Combine
import Foundation
import SwiftUI

struct NewListFieldView: View {
	private enum Field: Int, Hashable{
		case icon, title
	}
	
	@FocusState private var focusedField: Field?
	
	@State var newTitle: String = ""
	@State var newColor: String = ColorOptions.none.string
	@State var newSymbol = SymbolOptions.strings[0]
	
	var list: CD_List?
	
	@EnvironmentObject var navigationModel: NavigationModel
	
	var body: some View {
		VStack(spacing: 0) {
			NewListAttributeEditor(newTitle: $newTitle, newColor: $newColor, newSymbol: $newSymbol)
			
			Divider()
				.padding(.horizontal)
			
			HStack {
				
				TextField("New list", text: $newTitle, onCommit: {
					if list == nil {
						commitAction()
					}
				})
//					.frame(width: 150)
					.focused($focusedField, equals: .title)
			}
			.padding()
		}
		.task {
			focusedField = .title
			
			if let l = list {
				newTitle = l._title
				newColor = l._colorName
				newSymbol = l._symbol
			}
		}
//		.onChange(of: newTitle) { newValue in
//			if let l = list {
//				CoreDataHelper.updateList(title: newTitle, list: l)
//			}
//		}
		.onChange(of: newColor) { newValue in
			if let l = list {
				CoreDataHelper.updateList(color: newColor, list: l)
			}
		}
		.onChange(of: newSymbol) { newValue in
			if let l = list {
				CoreDataHelper.updateList(symbol: newSymbol, list: l)
			}
		}
	}
	
	func commitAction() {
		
		if newTitle != "" {
			CoreDataHelper.createList(
				title: newTitle,
				color: newColor,
				symbol: newSymbol,
				navigationModel: navigationModel
			)
			
			
			navigationModel.showingNewListField = false
		}
		
		newTitle = ""
		newColor = ColorOptions.none.string
		newSymbol = SymbolOptions.strings[0]
		
	}
}

struct NewListAttributeEditor: View {

	@Binding var newTitle: String
	@Binding var newColor: String
	@Binding var newSymbol: String
	
	var body: some View {
		VStack {
			ColorPicker(newColor: $newColor)

			
			Divider()
			
			SymbolPicker(symbol: $newSymbol, color: $newColor)
				.padding(.horizontal, 20)
				.padding(.leading)
		}
		.padding()
		.frame(width: 200)
	}
}
