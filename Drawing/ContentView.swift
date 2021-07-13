//
//  ContentView.swift
//  Drawing
//
//  Created by Bruce Gilmour on 2021-07-13.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        EmptyView()
    }
}

struct BackgroundView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Hello, world!")
                .frame(width: 200, height: 150)
                .background(Color.red)

            Text("Hello, world!")
                .frame(width: 200, height: 150)
                .border(Color.red, width: 20)

            Text("Hello, world!")
                .fontWeight(.bold)
                .frame(width: 200, height: 150)
                .foregroundColor(.white)
                .background(Image("barcelona-casa-mila").resizable())
        }
    }
}

struct ImagePaintView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Hello, world!")
                .frame(width: 300, height: 200)
                .border(ImagePaint(image: Image("barcelona-casa-mila"), scale: 0.2), width: 20)

            Text("Hello, world!")
                .frame(width: 300, height: 200)
                .border(ImagePaint(image: Image("barcelona-casa-mila"), sourceRect: CGRect(x: 0, y: 0.25, width: 1, height: 0.5), scale: 0.1), width: 20)

            Capsule()
                .strokeBorder(ImagePaint(image: Image("barcelona-casa-mila"), scale: 0.05), lineWidth: 30)
                .frame(width: 300, height: 200)
        }
    }
}

struct Triangle1View: View {
    var body: some View {
        Triangle()
            .fill(Color.red)
            .frame(width: 300, height: 300)
    }
}

struct Triangle2View: View {
    var body: some View {
        Triangle()
            .stroke(Color.red, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
            .frame(width: 300, height: 300)
    }
}

struct Arc1View: View {
    var body: some View {
        Arc(startAngle: .degrees(0), endAngle: .degrees(110), clockwise: true)
            .stroke(Color.blue, lineWidth: 10)
            .frame(width: 300, height: 300)
    }
}

struct Arc2View: View {
    var body: some View {
        Arc(startAngle: .degrees(-90), endAngle: .degrees(90), clockwise: true)
            .strokeBorder(Color.blue, style: StrokeStyle(lineWidth: 10, lineCap: .round))
    }
}

struct Circle1View: View {
    var body: some View {
        Circle()
            .stroke(Color.blue, lineWidth: 10)
    }
}

struct Circle2View: View {
    var body: some View {
        Circle()
            .strokeBorder(Color.blue, lineWidth: 10)
    }
}

struct Flower1View: View {
    @State private var petalOffset = -20.0
    @State private var petalWidth = 100.0

    var body: some View {
        VStack {
            Flower(petalOffset: petalOffset, petalWidth: petalWidth)
                .stroke(Color.red, lineWidth: 1)

            Text("Offset: \(petalOffset, specifier: "%.2f")")
            Slider(value: $petalOffset, in: -40 ... 40)
                .padding([.horizontal, .bottom])

            Text("Width: \(petalWidth, specifier: "%.2f")")
            Slider(value: $petalWidth, in: 0 ... 100)
                .padding(.horizontal)
        }
    }
}

struct Flower2View: View {
    @State private var petalOffset = -20.0
    @State private var petalWidth = 100.0

    var body: some View {
        VStack {
            Flower(petalOffset: petalOffset, petalWidth: petalWidth)
                .fill(Color.red, style: FillStyle(eoFill: true))

            Text("Offset: \(petalOffset, specifier: "%.2f")")
            Slider(value: $petalOffset, in: -40 ... 40)
                .padding([.horizontal, .bottom])

            Text("Width: \(petalWidth, specifier: "%.2f")")
            Slider(value: $petalWidth, in: 0 ... 100)
                .padding(.horizontal)
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))

        return path
    }
}

struct Arc: InsettableShape {
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool

    var insetAmount: CGFloat = 0

    func path(in rect: CGRect) -> Path {
        let rotationAdjustment = Angle.degrees(90)
        let modifiedStart = startAngle - rotationAdjustment
        let modifiedEnd = endAngle - rotationAdjustment

        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2 - insetAmount, startAngle: modifiedStart, endAngle: modifiedEnd, clockwise: !clockwise)
        return path
    }

    func inset(by amount: CGFloat) -> some InsettableShape {
        var arc = self
        arc.insetAmount += amount
        return arc
    }
}

struct Flower: Shape {
    var petalOffset: Double = -20
    var petalWidth: Double = 100

    func path(in rect: CGRect) -> Path {
        var path = Path()

        for number in stride(from: 0, to: CGFloat.pi * 2, by: CGFloat.pi / 8) {
            let rotation = CGAffineTransform(rotationAngle: number)
            let position = rotation.concatenating(CGAffineTransform(translationX: rect.width / 2, y: rect.height / 2))
            let originalPetal = Path(ellipseIn: CGRect(x: CGFloat(petalOffset), y: 0, width: CGFloat(petalWidth), height: rect.width / 2))
            let rotatedPetal = originalPetal.applying(position)

            path.addPath(rotatedPetal)
        }

        return path
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
