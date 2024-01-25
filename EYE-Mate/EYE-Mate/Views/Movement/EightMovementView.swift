//
//  EightMovementView.swift
//  EYE-Mate
//
//  Created by seongjun on 1/23/24.
//

import Combine
import SwiftUI


let width: CGFloat = 300
let height: CGFloat = 30

let originPoint = CGPoint(x: width / 2, y: 400)
let rightPoint = CGPoint(x: width , y: 400)
let leftPoint = CGPoint(x: 0 , y: 400)

private var samplePath : Path {
    let controlPoint1 = CGPoint(x: originPoint.x + (rightPoint.x - originPoint.x) / 5, y:  400 + height)
    let controlPoint2 = CGPoint(x: rightPoint.x, y: 400 + height * 1.8)
    let controlPoint3 = CGPoint(x: rightPoint.x, y: 400 - height * 1.8)
    let controlPoint4 = CGPoint(x: originPoint.x + (rightPoint.x - originPoint.x) / 5, y:  400 - height)

    let controlPoint5 = CGPoint(x: originPoint.x - (originPoint.x - leftPoint.x) / 5, y:  400 + height)
    let controlPoint6 = CGPoint(x: leftPoint.x, y: 400 + height * 1.8)
    let controlPoint7 = CGPoint(x: leftPoint.x, y: 400 - height * 1.8)
    let controlPoint8 = CGPoint(x: originPoint.x - (originPoint.x - leftPoint.x) / 5, y:  400 - height)

    var result = Path()

    result.move(to: originPoint)
    result.addCurve(to: rightPoint, control1: controlPoint1, control2: controlPoint2)
    result.addCurve(to: originPoint, control1: controlPoint3, control2: controlPoint4)
    result.addCurve(to: leftPoint, control1: controlPoint5, control2: controlPoint6)
    result.addCurve(to: originPoint, control1: controlPoint7, control2: controlPoint8)

    return result
}

struct MovingPoint: Animatable, View {
    var time: CGFloat
    let path: Path
    let start: CGPoint

    var animatableData: CGFloat {
        get { time }
        set { time = newValue }
    }

    var body: some View {
        ZStack {
            samplePath.stroke(style: StrokeStyle(lineWidth: 20))
            //            Text("🌕")
            //                .position(
            //                    samplePath
            //                        .trimmedPath(from: 0,
            //                                     to: time)
            //                        .currentPoint ?? start
            //                )
        }

    }
}

struct MovingDotAnimationView: View {
    let path: Path
    let start: CGPoint
    let duration: Double = 2
    let repeatCount: Int = 8

    @State private var isMoving = false
    @State private var maxTime: CGFloat = 0
    @State private var currentRepeatCount: Int = 0

    var body: some View {
        VStack {
            MovingPoint(time: maxTime, path: path, start: start)
                .animation(.linear(duration: duration), value: maxTime)
        }.onAppear {
            animate()
        }

    }

    private func animate() {
        maxTime = 1
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            maxTime = 0
            print(maxTime)
            animate()
        }
    }
}


struct EightMovementView: View {
    var body: some View {
        MovingDotAnimationView(path: samplePath, start: originPoint)
    }
}

#Preview {
    EightMovementView()
}
