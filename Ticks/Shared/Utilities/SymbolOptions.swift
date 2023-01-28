//
//  SymbolOptions.swift
//  SymbolOptions
//
//  Created by Frank on 9/12/21.
//

import Foundation
import SwiftUI

struct SymbolOptions {
	static let strings = ["folder.fill", "book.closed.fill", "bookmark.fill", "books.vertical.fill", "pin.fill", "house.fill", "gift.fill", "graduationcap.fill", "bag.fill", "pencil.and.outline", "creditcard.fill", "fork.knife", "takeoutbag.and.cup.and.straw", "pills.fill", "building.2.fill", "building.columns.fill", "tv.inset.filled", "music.note", "music.mic", "headphones", "gamecontroller.fill", "desktopcomputer", "laptopcomputer", "leaf.fill", "pawprint.fill", "cart.fill", "archivebox.fill", "shippingbox.fill", "sun.max.fill", "moon.stars.fill", "message.fill", "bubble.left.fill", "eyeglasses", "car.fill", "heart.fill", "globe", "globe.americas.fill", "globe.europe.africa.fill", "globe.asia.australia.fill", "hammer.fill", "wrench.and.screwdriver.fill", "tshirt.fill", "gear", "flag.fill", "checklist", "list.bullet", "scissors", "chevron.left.forwardslash.chevron.right", "curlybraces", "camera.fill", "mappin.and.ellipse", "dice.fill", "trash.fill", "tray.fill", "calendar", "paperclip", "bell.fill", "envelope.fill", "magnifyingglass", "doc.text.magnifyingglass", "waveform.path", "bolt.fill", "chart.line.uptrend.xyaxis", "chart.pie.fill", "chart.bar.fill", "key.fill", "pianokeys", "film", "hourglass", "briefcase.fill", "atom", "paperplane.fill", "airplane.departure", "airplane", "safari.fill", "bicycle", "keyboard", "shield.fill", "scribble.variable", "lasso.and.sparkles", "externaldrive.fill", "doc.fill", "terminal.fill", "rosette", "ticket.fill", "link", "person.fill", "person.2.fill", "zzz", "moon.zzz.fill", "sparkles", "cloud.sun", "filemenu.and.cursorarrow", "rectangle.3.offgrid", "square.grid.3x2.fill", "checkmark.seal.fill", "drop.fill"]
	
	static var symbols: [Image] {
		var array = [Image]()
		
		for s in strings {
			array.append(Image(systemName: "\(s)"))
		}
		
		return array
	}
}

struct SymbolPicker: View {
	
	@Binding var symbol: String
	@Binding var color: String
	
	var selectionColor: Color {
		if ColorOptions.getColorFromString(string: color).color == Color.secondary {
			return Color.accentColor
		} else {
			return ColorOptions.getColorFromString(string: color).color
		}
	}
	
	var body: some View {
		ScrollView(.vertical) {
			VStack {
				LazyVGrid(columns: [GridItem(), GridItem(), GridItem(), GridItem(), GridItem()], spacing: 10) {
					ForEach(SymbolOptions.strings, id: \.self) { string in
						Button {
							symbol = string
						} label: {
							ZStack {
								if string == symbol {
									Image(systemName: string)
										.foregroundColor(.white)
										.blur(radius: 3)
										.opacity(0.5)
								}
								Image(systemName: string)
							}
						}
						.buttonStyle(.plain)
						.padding(.horizontal)
						.foregroundStyle(string == symbol ? selectionColor : Color.secondary)
					}
				}
				.padding(.vertical, 10)
			}
		}
		.frame(width: 200, height: 90)
	}
}
