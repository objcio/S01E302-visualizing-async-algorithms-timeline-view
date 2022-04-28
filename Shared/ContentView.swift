import SwiftUI

enum Value: Hashable, Sendable {
    case int(Int)
    case string(String)
}

struct Event: Identifiable, Hashable, Sendable {
    var id: Int
    var time: TimeInterval
    var color: Color = .green
    var value: Value
}

var sampleInt: [Event] = [
    .init(id: 0, time:  0, color: .red, value: .int(1)),
    .init(id: 1, time:  1, color: .red, value: .int(2)),
    .init(id: 2, time:  2, color: .red, value: .int(3)),
    .init(id: 3, time:  5, color: .red, value: .int(4)),
    .init(id: 4, time:  8, color: .red, value: .int(5)),
]

var sampleString: [Event] = [
    .init(id: 100_0, time:  1.5, value: .string("a")),
    .init(id: 100_1, time:  2.5, value: .string("b")),
    .init(id: 100_2, time:  4.5, value: .string("c")),
    .init(id: 100_3, time:  6.5, value: .string("d")),
    .init(id: 100_4, time:  7.5, value: .string("e")),
]

extension Value: View {
    var body: some View {
        switch self {
        case .int(let i): Text("\(i)")
        case .string(let s): Text(s)
        }
    }
}

struct TimelineView: View {
    var events: [Event]
    var duration: TimeInterval
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.secondary)
                    .frame(height: 1)
                ForEach(0..<Int(duration.rounded(.up))) { tick in
                    Rectangle()
                        .frame(width: 1)
                        .foregroundColor(.secondary)
                        .alignmentGuide(.leading) { dim in
                            let relativeTime = CGFloat(tick) / duration
                            return -(proxy.size.width-30) * relativeTime
                        }
                }
                .offset(x: 15)
                ForEach(events) { event in
                    event.value
                        .frame(width: 30, height: 30)
                        .background {
                            Circle().fill(event.color)
                        }
                        .alignmentGuide(.leading) { dim in
                            let relativeTime = event.time / duration
                            return -(proxy.size.width-30) * relativeTime
                        }
                        .help("\(event.time)")
                }
            }
        }
        .frame(height: 30)
    }
}
struct ContentView: View {
    var duration: TimeInterval {
        max(sampleInt.last!.time, sampleString.last!.time)
    }
    
    var body: some View {
        VStack {
            TimelineView(events: sampleInt, duration: duration)
            TimelineView(events: sampleString, duration: duration)
        }
        .padding(20)
    }
}
