//
//  ColorOptions.swift
//  ColorOptions
//
//  Created by Frank on 9/12/21.
//

import Foundation
import SwiftUI

struct ColorOptions {
	
	static var previewRows: some View {
		LazyVGrid(columns: [GridItem(spacing: 30), GridItem(spacing: 30), GridItem(spacing: 30), GridItem(spacing: 30), GridItem(spacing: 30)]){
			ForEach(ColorOptions.options) { option in
				Circle().fill(option.color).frame(width: 50, height: 50)
			}
		}
		.padding(.horizontal)
		.frame(minWidth: 400, minHeight: 200)
	}
	
	static func getIcon(symbol: String? = "", color: String?) -> some View {
		if SymbolOptions.strings.contains(symbol ?? "") { //symbol has a usable value
			return Image(systemName: "\(symbol ?? "")").foregroundColor(ColorOptions.getColorFromString(string: color).color)
		} else {
			return Image(systemName: "circle.fill").foregroundColor(ColorOptions.getColorFromString(string: color).color)
		}
	}
	
	static func getColorFromString(string c: String?) -> ColorOption {
		switch c {
			case ColorOptions.white.string:
				return ColorOptions.white
			case ColorOptions.black.string:
				return ColorOptions.black
			case ColorOptions.gray.string:
				return ColorOptions.gray
			case ColorOptions.blue.string:
				return ColorOptions.blue
			case ColorOptions.teal.string:
				return ColorOptions.teal
			case ColorOptions.green.string:
				return ColorOptions.green
			case ColorOptions.indigo.string:
				return ColorOptions.indigo
			case ColorOptions.yellow.string:
				return ColorOptions.yellow
			case ColorOptions.brown.string:
				return ColorOptions.brown
			case ColorOptions.cyan.string:
				return ColorOptions.cyan
			case ColorOptions.red.string:
				return ColorOptions.red
			case ColorOptions.purple.string:
				return ColorOptions.purple
			case ColorOptions.pink.string:
				return ColorOptions.pink
			case ColorOptions.mint.string:
				return ColorOptions.mint
			case ColorOptions.orange.string:
				return ColorOptions.orange
			case ColorOptions.none.string:
				return ColorOptions.none
			default:
				return ColorOptions.none
		}
	}
	
	static let options: [ColorOption] = [
		mint,
		cyan,
		blue,
		indigo,
		green,
		purple,
		pink,
		//		white,
		//		gray,
		//		black,
		//		teal,
		red,
		orange,
		//		brown,
		yellow
	]
	
	static let black = ColorOption(Color.black, "black")
	static let gray = ColorOption(Color.gray, "gray")
	static let white = ColorOption(Color.white, "white")
	static let purple = ColorOption(Color(red: 0.708, green: 0.446, blue: 0.935, opacity: 1.000), "purple")
	static let indigo = ColorOption(Color(red: 0.435, green: 0.454, blue: 0.904, opacity: 1.000), "indigo")
	static let blue = ColorOption(Color(red: 0.212, green: 0.616, blue: 0.879, opacity: 1.000), "blue")
	static let teal = ColorOption(Color.teal, "teal")
	static let green = ColorOption(Color(red: 0.551, green: 0.920, blue: 0.505, opacity: 1.000), "green")
	static let yellow = ColorOption(Color.yellow, "yellow")
	static let brown = ColorOption(Color.brown, "brown")
	static let cyan = ColorOption(Color(red: 0.525, green: 0.793, blue: 0.861, opacity: 1.000), "cyan")
	static let red = ColorOption(Color(red: 0.943, green: 0.442, blue: 0.365, opacity: 1.000), "red")
	static let pink = ColorOption(Color(red: 1.000, green: 0.718, blue: 1.000, opacity: 1.000), "pink")
	static let mint = ColorOption(Color(red: 0.513, green: 0.875, blue: 0.851, opacity: 1.000), "mint")
	static let orange = ColorOption(Color.orange, "orange")
	static let none = ColorOption(Color.secondary, "none")
	
}

struct ColorOption: Identifiable, Hashable {
	internal init(_ color: Color, _ title: String) {
		self.color = color
		self.string = title
	}
	
	let id = UUID()
	let color: Color
	let string: String
}

struct ColorPicker: View {
	
	@Binding var newColor: String
	
	var body: some View {
		LazyVGrid(columns: Array.init(repeating: GridItem(), count: 5), alignment: .center, spacing: 10) {
			ForEach(ColorOptions.options) { option in
				Button {
					newColor = option.string
				} label: {
					Circle()
						.fill(option.color)
						.frame(width: 25, height: 25)
						.padding(-3)
						.overlay {
							if option.string == newColor {
								ZStack {
									Circle().stroke(Color.white, lineWidth: 2)
										.foregroundColor(.white)
										.blur(radius: 3)
										.opacity(0.5)
									
									Circle().stroke(Color.white, lineWidth: 2)
								}
							}
						}
						.padding(3)
				}
				.buttonStyle(.plain)
			}
		}
		
		Button {
			newColor = ColorOptions.none.string
		} label: {
			ZStack {
				Capsule()
					.padding(-3)
					.overlay {
						if ColorOptions.none.string == newColor {
							Capsule().stroke(Color.white, lineWidth: 2)
						}
					}
					.padding(3)
				
				Text("Default Color")
					.foregroundColor(.white)
					.padding(.vertical, 5)
			}
		}
		.buttonStyle(.borderless)
	}
}
