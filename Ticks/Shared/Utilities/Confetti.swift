//
//  Confetti.swift
//  Confetti
//
//  Created by Frank on 9/30/21.
//

import SwiftUI

//https://betterprogramming.pub/creating-confetti-particle-effects-using-swiftui-afda4240de6b

struct FireworkParticlesGeometryEffect: GeometryEffect {
	var time : Double
	var speed = Double.random(in: 20 ... 200)
	var direction = Double.random(in: -Double.pi ...  Double.pi)
	
	var animatableData: Double {
		get { time }
		set { time = newValue }
	}
	func effectValue(size: CGSize) -> ProjectionTransform {
		let xTranslation = speed * cos(direction) * time
		let yTranslation = speed * sin(direction) * time
		let affineTranslation =  CGAffineTransform(translationX: xTranslation, y: yTranslation)
		return ProjectionTransform(affineTranslation)
	}
}

struct ParticlesModifier: ViewModifier {
	@State var time = 0.0
	@State var scale = 0.1
	let duration = 3.0
	
	func body(content: Content) -> some View {
		ZStack {
			ForEach(0..<80, id: \.self) { index in
				content
					.hueRotation(Angle(degrees: time * 80))
					.scaleEffect(scale)
					.modifier(FireworkParticlesGeometryEffect(time: time))
					.opacity(((duration-time) / duration))
			}
		}
		.onAppear {
			withAnimation (.easeOut(duration: duration)) {
				self.time = duration
				self.scale = 1.0
			}
		}
	}
}

struct SampleView: View {
	
	@State var confetti = false
	
	var body: some View {
		ZStack {
			Button("Confetti") {
				confetti = false
				confetti = true
			}
			
			Circle()
				.fill(Color.blue)
				.frame(width: 12, height: 12)
				.if(confetti) {
					$0.modifier(ParticlesModifier())
				}
				.offset(x: -100, y: -50)
			
			Circle()
				.fill(Color.red)
				.frame(width: 12, height: 12)
				.if(confetti) {
					$0.modifier(ParticlesModifier())
				}
				.offset(x: 60, y: 70)
		}
	}
}

struct SampleViewPreviews: PreviewProvider {
	static var previews: some View {
		SampleView()
	}
}

//https://stackoverflow.com/questions/57467353/conditional-property-in-swiftui
extension View {
	@ViewBuilder
	func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
		if condition { transform(self) }
		else { self }
	}
}
