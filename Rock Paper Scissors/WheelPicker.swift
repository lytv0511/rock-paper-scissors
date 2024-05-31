//
//  WheelPicker.swift
//  Rock Paper Scissors
//
//  Created by Vincent Leong on 5/31/24.
//

import SwiftUI

public struct WheelPicker: View {
    let choices: [String]
    @Binding var choice: String
    @State private var rotation: Double = 0
    @State private var finalAngle: Double = 0
    @State private var initialTouchAngle: Double? = nil
    let numberOfTicks = 100
    
    public var body: some View {
        VStack {
            GeometryReader { geometry in
                ZStack {
                    Circle()
                        .stroke(lineWidth: 1)
                        .foregroundColor(.gray)
                    
                    ForEach(0..<numberOfTicks, id: \.self) { index in
                        Rectangle()
                            .frame(width: 2, height: index % 5 == 0 ? 20 : 10)
                            .offset(y: -geometry.size.width/2 + 15 + (index % 5 == 0 ? -5 : 0))
                            .rotationEffect(Angle(degrees: 360 / Double(numberOfTicks) * Double(index)))
                    }
                    ForEach(0..<choices.count, id: \.self) { index in
                        Text(self.choices[index])
                            .offset(y: -geometry.size.width/2 + 50)
                            .rotationEffect(Angle(degrees: 360 / Double(choices.count) * Double(index)))
                            .rotationEffect(Angle(degrees: self.finalAngle), anchor: .center)
                            .font(.title)
                    }
                }
                
                .contentShape(Circle())
                .clipped()
                .frame(width: geometry.size.width, height: geometry.size.width)
                .rotationEffect(Angle(degrees: self.rotation))
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let vector = CGVector(dx: value.location.x - geometry.size.width / 2,
                                                  dy: value.location.y - geometry.size.height / 2)
                            let angle = atan2(vector.dy, vector.dx).radiansToDegrees
                            if self.initialTouchAngle == nil {
                                self.initialTouchAngle = angle
                            }
                            self.rotation = angle - (self.initialTouchAngle ?? 0)
                        }
                        .onEnded { _ in
                            self.finalAngle += self.rotation
                            self.rotation = 0
                            self.initialTouchAngle = nil
                            let normalizedAngle = (360 - self.finalAngle.truncatingRemainder(dividingBy: 360)) + 360 / Double(choices.count) / 2
                            let index = Int((normalizedAngle / (360 / Double(choices.count))).truncatingRemainder(dividingBy: Double(choices.count)))
                            self.choice = self.choices[index]
                        }
                )
            }
            .aspectRatio(1, contentMode: .fit)
            .padding(.horizontal)
        }
    }
}

extension CGFloat {
    var radiansToDegrees: Double {
        return Double(self) * 180 / .pi
    }
}


