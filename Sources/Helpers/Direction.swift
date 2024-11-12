//
//  Direction.swift
//  
//
//  Created by Barna Nemeth on 03/12/2024.
//

// MARK: 2d directions
enum Turn: CaseIterable {
    case clockwise // "right"
    case counterclockwise // "left"

    static let right = Turn.clockwise
    static let left = Turn.counterclockwise
}

enum Direction: String, CaseIterable {
    case n, w, s, e
    case nw, ne, sw, se

    static let up = Direction.n
    static let down = Direction.s
    static let left = Direction.w
    static let right = Direction.e

    static let orthogonal: [Direction] = [ .n, .w, .s, .e ]
    static let diagonal: [Direction] = [ .nw, .ne, .sw, .se ]

    var offset: Point {
        switch self {
        case .n: return Point(0, -1)
        case .w: return Point(-1, 0)
        case .s: return Point(0, 1)
        case .e: return Point(1, 0)
        case .nw: return Point(-1, -1)
        case .ne: return Point(1, -1)
        case .sw: return Point(-1, 1)
        case .se: return Point(1, 1)
        }
    }

    var opposite: Direction {
        switch self {
        case .n: return .s
        case .s: return .n
        case .w: return .e
        case .e: return .w
        case .ne: return .sw
        case .nw: return .se
        case .se: return .nw
        case .sw: return .ne
        }
    }

    func turned(_ turn: Turn, by degrees: Int = 90) -> Direction {
        switch (turn, degrees) {
        case (.clockwise, 90):
            switch self {
            case .n: return .e
            case .e: return .s
            case .s: return .w
            case .w: return .n
            case .ne: return .se
            case .nw: return .ne
            case .se: return .sw
            case .sw: return .nw
            }
        case (.clockwise, 45):
            switch self {
            case .n: return .ne
            case .e: return .se
            case .s: return .sw
            case .w: return .nw
            case .ne: return .e
            case .nw: return .n
            case .se: return .s
            case .sw: return .w
            }
        case (.counterclockwise, 90):
            switch self {
            case .n: return .w
            case .e: return .n
            case .s: return .e
            case .w: return .s
            case .ne: return .nw
            case .nw: return .sw
            case .se: return .ne
            case .sw: return .se
            }
        case (.counterclockwise, 45):
            switch self {
            case .n: return .nw
            case .e: return .ne
            case .s: return .se
            case .w: return .sw
            case .ne: return .n
            case .nw: return .w
            case .se: return .e
            case .sw: return .s
            }
        default:
            fatalError("unsupported turn degrees \(degrees)")
        }
    }
}

