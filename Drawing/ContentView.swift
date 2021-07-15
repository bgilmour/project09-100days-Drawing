//
//  ContentView.swift
//  Drawing
//
//  Created by Bruce Gilmour on 2021-07-13.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        AnimatedArrowsView()
    }
}

struct AnimatedArrowsView: View {
    @State private var shaftWidthRatio = 0.25
    @State private var shaftLengthRatio = 0.7
    @State private var tipWidthRatio = 0.5

    var body: some View {
        VStack {
            SimpleArrow(shaftWidthRatio: shaftWidthRatio, shaftLengthRatio: shaftLengthRatio, tipWidthRatio: tipWidthRatio)
                .stroke(Color.black, lineWidth: 2)
                .background(SimpleArrow(shaftWidthRatio: shaftWidthRatio, shaftLengthRatio: shaftLengthRatio, tipWidthRatio: tipWidthRatio).fill(Color.blue))
                .onTapGesture {
                    withAnimation(.linear(duration: 1)) {
                        shaftWidthRatio = Double.random(in: 0.1 ... tipWidthRatio)
                        shaftLengthRatio = Double.random(in: 0.1 ... 0.8)
                        tipWidthRatio = Double.random(in: shaftWidthRatio ... 1.0)
                    }
                }
                .frame(width: 300, height: 200)
                .animation(.linear)
                .overlay(Rectangle().stroke(Color.red, lineWidth: 1))
                .padding([.horizontal, .bottom])

            Arrow(shaftWidthRatio: shaftWidthRatio, shaftLengthRatio: shaftLengthRatio, tipWidthRatio: tipWidthRatio)
                .stroke(Color.black, lineWidth: 2)
                .background(Arrow(shaftWidthRatio: shaftWidthRatio, shaftLengthRatio: shaftLengthRatio, tipWidthRatio: tipWidthRatio).fill(Color.purple))
                .onTapGesture {
                    withAnimation(.linear(duration: 1)) {
                        shaftWidthRatio = Double.random(in: 0.1 ... tipWidthRatio)
                        shaftLengthRatio = Double.random(in: 0.1 ... 0.8)
                        tipWidthRatio = Double.random(in: shaftWidthRatio ... 1.0)
                    }
                }
                .frame(width: 300, height: 200)
                .animation(.linear)
                .overlay(Rectangle().stroke(Color.red, lineWidth: 1))
                .padding([.horizontal, .bottom])

            Group {
                Text("Shaft width ratio: \(shaftWidthRatio, specifier: "%.2f")")
                Slider(value: $shaftWidthRatio, in: 0.1 ... tipWidthRatio)
                    .padding([.horizontal, .bottom])

                Text("Shaft length ratio: \(shaftLengthRatio, specifier: "%.2f")")
                Slider(value: $shaftLengthRatio, in: 0.1 ... 0.8)
                    .padding([.horizontal, .bottom])

                Text("Tip width ratio: \(tipWidthRatio, specifier: "%.2f")")
                Slider(value: $tipWidthRatio, in: shaftWidthRatio ... 1.0)
                    .padding([.horizontal, .bottom])
            }
        }
    }
}

struct Arrow: Shape {
    var shaftWidthRatio = 0.25
    var shaftLengthRatio = 0.7
    var tipWidthRatio = 0.5

    func path(in rect: CGRect) -> Path {
        let shaftLength = rect.width * CGFloat(shaftLengthRatio)
        let shaftWidth = rect.height * CGFloat(shaftWidthRatio)
        let tipWidth = rect.height * CGFloat(tipWidthRatio)

        var path = Path()

        path.move(to: CGPoint(x: 0, y: rect.midY - shaftWidth / 2))
        path.addLine(to: CGPoint(x: shaftLength, y: rect.midY - shaftWidth / 2))
        path.addLine(to: CGPoint(x: shaftLength, y: rect.midY - tipWidth / 2))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height / 2))
        path.addLine(to: CGPoint(x: shaftLength, y: rect.midY + tipWidth / 2))
        path.addLine(to: CGPoint(x: shaftLength, y: rect.midY + shaftWidth / 2))
        path.addLine(to: CGPoint(x: 0, y: rect.midY + shaftWidth / 2))
        path.addLine(to: CGPoint(x: 0, y: rect.midY - shaftWidth / 2))

        return path
    }

    var animatableData: AnimatablePair<Double, AnimatablePair<Double, Double>> {
        get {
            AnimatablePair(shaftWidthRatio, AnimatablePair(shaftLengthRatio, tipWidthRatio))
        }

        set {
            shaftWidthRatio = newValue.first
            shaftLengthRatio = newValue.second.first
            tipWidthRatio = newValue.second.second
        }
    }
}

struct SimpleArrow: Shape {
    var shaftWidthRatio = 0.25
    var shaftLengthRatio = 0.7
    var tipWidthRatio = 0.5


    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.addRect(CGRect(x: 0, y: rect.midY - rect.height * CGFloat(shaftWidthRatio) / 2, width: rect.width * CGFloat(shaftLengthRatio), height: rect.height * CGFloat(shaftWidthRatio)))

        path.move(to: CGPoint(x: rect.width * CGFloat(shaftLengthRatio), y: rect.midY - rect.height * CGFloat(tipWidthRatio) / 2))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height / 2))
        path.addLine(to: CGPoint(x: rect.width * CGFloat(shaftLengthRatio), y: rect.midY + rect.height * CGFloat(tipWidthRatio) / 2))
        path.addLine(to:CGPoint(x: rect.width * CGFloat(shaftLengthRatio), y: rect.midY - rect.height * CGFloat(tipWidthRatio) / 2))

        return path
    }

    var animatableData: AnimatablePair<Double, AnimatablePair<Double, Double>> {
        get {
            AnimatablePair(shaftWidthRatio, AnimatablePair(shaftLengthRatio, tipWidthRatio))
        }

        set {
            shaftWidthRatio = newValue.first
            shaftLengthRatio = newValue.second.first
            tipWidthRatio = newValue.second.second
        }
    }
}

struct DrawingTabView: View {
    var body: some View {
        TabView {
            BlendMode2View()
                .tabItem {
                    Label("Blend", systemImage: "arrow.triangle.merge")
                }

            OverlappingCircleView()
                .tabItem {
                    Label("Overlap", systemImage: "circlebadge.2")
                }

            ColorCycle2View()
                .tabItem {
                    Label("Cycle", systemImage: "arrow.triangle.2.circlepath")
                }

            Flower2View()
                .tabItem {
                    Label("Flower", systemImage: "leaf")
                }

            SpirographView()
                .tabItem {
                    Label("Spirograph", systemImage: "line.3.crossed.swirl.circle")
                }
        }
    }
}

struct SpirographView: View {
    @State private var innerRadius = 125.0
    @State private var outerRadius = 75.0
    @State private var distance = 25.0
    @State private var amount: CGFloat = 1.0
    @State private var hue = 0.6

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            Spirograph(innerRadius: Int(innerRadius), outerRadius: Int(outerRadius), distance: Int(distance), amount: amount)
                .stroke(Color(hue: hue, saturation: 1, brightness: 1), lineWidth: 1)
                .frame(width: 300, height: 300)

            Spacer()

            Group {
                Text("Inner radius: \(Int(innerRadius))")
                Slider(value: $innerRadius, in: 10 ... 150, step: 1)
                    .padding([.horizontal, .bottom])

                Text("Outer radius: \(Int(outerRadius))")
                Slider(value: $outerRadius, in: 10 ... 150, step: 1)
                    .padding([.horizontal, .bottom])

                Text("Distance: \(Int(distance))")
                Slider(value: $distance, in: 1 ... 150, step: 1)
                    .padding([.horizontal, .bottom])

                Text("Amount: \(amount, specifier: "%.2f")")
                Slider(value: $amount)
                    .padding([.horizontal, .bottom])

                Text("Color: \(hue, specifier: "%.2f")")
                Slider(value: $hue)
                    .padding([.horizontal, .bottom])
            }
        }
    }
}

struct CheckerboardView: View {
    @State private var rows = 4
    @State private var columns = 4

    var body: some View {
        Checkerboard(rows: rows, columns: columns)
            .onTapGesture {
                withAnimation(.linear(duration: 3)) {
                    rows = 8
                    columns = 16
                }
            }
    }
}

struct TrapezoidView: View {
    @State private var insetAmount: CGFloat = 50

    var body: some View {
        Trapezoid(insetAmount: insetAmount)
            .frame(width: 200, height: 100)
            .onTapGesture {
                withAnimation {
                    insetAmount = CGFloat.random(in: 10 ... 90)
                }
            }
    }
}

struct SaturationBlurView: View {
    @State private var amount: CGFloat = 0.0

    var body: some View {
        VStack {
            Image("barcelona-casa-mila")
                .resizable()
                .scaledToFill()
                .frame(width: 400, height: 300)
                .saturation(Double(amount))
                .blur(radius: (1 - amount) * 10)

            HStack {
                Text("Effect: \(amount, specifier: "%.2f")")
                    .padding(.trailing)
                Slider(value: $amount)
            }
            .padding()
        }
    }
}

struct OverlappingCircleView: View {
    @State private var amount: CGFloat = 0.5
    @State private var selectedMode = 0
    @State private var useDynamicColors = true

    static let modes: [BlendMode] = [.screen, .difference, .exclusion]
    static let modeNames: [String] = ["screen", "difference", "exclusion"]

    var body: some View {
        VStack {
            Text("OverlappingCircleView")
                .font(.title)
                .foregroundColor(.white)
                .padding()

            ZStack {
                Circle()
                    .fill(useDynamicColors ? Color.red : Color(red: 1, green: 0, blue: 0))
                    .frame(width: 250 * amount)
                    .offset(x: -50, y: -80)
                    .blendMode(Self.modes[selectedMode])

                Circle()
                    .fill(useDynamicColors ? Color.green : Color(red: 0, green: 1, blue: 0))
                    .frame(width: 250 * amount)
                    .offset(x: 50, y: -80)
                    .blendMode(Self.modes[selectedMode])

                Circle()
                    .fill(useDynamicColors ? Color.blue : Color(red: 0, green: 0, blue: 1))
                    .frame(width: 250 * amount)
                    .blendMode(Self.modes[selectedMode])
            }
            .frame(width: 300, height: 300)

            VStack(spacing: 20) {
                Toggle("Use dynamic colors", isOn: $useDynamicColors)

                HStack {
                    Text("Size: \(amount, specifier: "%.2f")")
                        .padding(.trailing)
                    Slider(value: $amount, in: 0.25 ... 1.0)
                }

                Stepper("Mode: \(selectedMode) (\(Self.modeNames[selectedMode]))", value: $selectedMode, in: 0 ... Self.modes.count - 1)
            }
            .padding()
            .background(Color(red: 0.95, green: 0.95, blue: 0.95))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
    }

}

struct BlendMode1View: View {
    static let colors: [Color] = [.white, .red, .green, .yellow, .orange, .pink, .purple, .blue, .black]

    @State private var selectedColor = 0

    var body: some View {
        VStack {
            ZStack {
                Image("barcelona-casa-mila").resizable().scaledToFill()

                Rectangle()
                    .fill(Self.colors[selectedColor])
                    .blendMode(.multiply)

            }
            .frame(width: 400, height: 300)
            .overlay(Rectangle().stroke(Color.black, lineWidth: 2))
            .clipped()

            Stepper("Color: \(selectedColor) (\(Self.colors[selectedColor].description))", value: $selectedColor, in: 0 ... Self.colors.count - 1)
                .padding()
        }
    }
}

struct BlendMode2View: View {
    static let colors: [Color] = [.white, .red, .green, .yellow, .orange, .pink, .purple, .blue]

    @State private var selectedColor = 0

    var body: some View {
        VStack {
            Image("barcelona-casa-mila")
                .resizable()
                .scaledToFill()
                .colorMultiply(Self.colors[selectedColor])
                .frame(width: 400, height: 300)
                .clipped()

            Stepper("Color: \(selectedColor) (\(Self.colors[selectedColor].description))", value: $selectedColor, in: 0 ... Self.colors.count - 1)
                .padding()
        }
    }
}

struct ColorCycle1View: View {
    @State private var colorCycle = 0.0

    var body: some View {
        VStack {
            Spacer()

            ColorCyclingCircle(amount: colorCycle)
                .frame(width: 300, height: 300)

            Spacer()

            Text("Hue: \(colorCycle, specifier: "%.2f")")

            Slider(value: $colorCycle)

            Spacer()
        }
        .padding()
    }
}

struct ColorCycle2View: View {
    @State private var colorCycle = 0.0

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            ComplexColorCyclingCircle(amount: colorCycle)
                .frame(width: 300, height: 300)

            Spacer()

            Text("Hue: \(colorCycle, specifier: "%.2f")")

            Slider(value: $colorCycle)

            Spacer()
        }
        .padding()
    }
}

struct ColorCyclingCircle: View {
    var amount = 0.0
    var steps = 100

    var body: some View {
        ZStack {
            ForEach(0 ..< steps) { value in
                Circle()
                    .inset(by: CGFloat(value))
                    .strokeBorder(color(for: value, brightness: 1), lineWidth: 2)
            }
        }
    }

    func color(for value: Int, brightness: Double) -> Color {
        var targetHue = Double(value) / Double(steps) + amount

        if targetHue > 1 {
            targetHue -= 1
        }

        return Color(hue: targetHue, saturation: 1, brightness: brightness)
    }
}

struct ComplexColorCyclingCircle: View {
    var amount = 0.0
    var steps = 100

    var body: some View {
        ZStack {
            ForEach(0 ..< steps) { value in
                Circle()
                    .inset(by: CGFloat(value))
                    .strokeBorder(LinearGradient(gradient: Gradient(colors: [
                        color(for: value, brightness: 1),
                        color(for: value, brightness: 0.25)
                    ]), startPoint: .top, endPoint: .bottom), lineWidth: 2)
            }
        }
        .drawingGroup()
    }

    func color(for value: Int, brightness: Double) -> Color {
        var targetHue = Double(value) / Double(steps) + amount

        if targetHue > 1 {
            targetHue -= 1
        }

        return Color(hue: targetHue, saturation: 1, brightness: brightness)
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
                .padding([.horizontal, .bottom])
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
                .padding([.horizontal, .bottom])
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

struct Trapezoid: Shape {
    var insetAmount: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: 0, y: rect.maxY))
        path.addLine(to: CGPoint(x: insetAmount, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - insetAmount, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: 0, y: rect.maxY))

        return path
    }

    var animatableData: CGFloat {
        get { insetAmount }
        set { insetAmount = newValue }
    }
}

struct Checkerboard: Shape {
    var rows: Int
    var columns: Int

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let rowSize = rect.height / CGFloat(rows)
        let columnSize = rect.width / CGFloat(columns)

        for row in 0 ..< rows {
            for column in 0 ..< columns {
                if (row + column).isMultiple(of: 2) {
                    let startX = columnSize * CGFloat(column)
                    let startY = rowSize * CGFloat(row)

                    let rect = CGRect(x: startX, y: startY, width: columnSize, height: rowSize)
                    path.addRect(rect)
                }
            }
        }

        return path
    }

    var animatableData: AnimatablePair<Double, Double> {
        get {
            AnimatableData(Double(rows), Double(columns))
        }

        set {
            rows = Int(newValue.first)
            columns = Int(newValue.second)
        }
    }
}

struct Spirograph: Shape {
    let innerRadius: Int
    let outerRadius: Int
    let distance: Int
    let amount: CGFloat

    func path(in rect: CGRect) -> Path {
        let divisor = gcd(innerRadius, outerRadius)
        let outerRadius = CGFloat(self.outerRadius)
        let innerRadius = CGFloat(self.innerRadius)
        let distance = CGFloat(self.distance)
        let difference = innerRadius - outerRadius
        let endPoint = ceil(2 * CGFloat.pi * outerRadius / CGFloat(divisor)) * amount

        var path = Path()

        for theta in stride(from: 0, to: endPoint, by: 0.01) {
            var x = difference * cos(theta) + distance * cos(difference / outerRadius * theta)
            var y = difference * sin(theta) - distance * sin(difference / outerRadius * theta)

            x += rect.width / 2
            y += rect.height / 2

            if theta == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }

        return path
    }

    func gcd(_ a: Int, _ b: Int) -> Int {
        var a = a
        var b = b

        while b != 0 {
            let temp = b
            b = a % b
            a = temp
        }

        return a
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
