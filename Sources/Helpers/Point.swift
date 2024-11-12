//
//  Point.swift
//  
//
//  Created by Barna Nemeth on 03/12/2024.
//

/// A point in a 2d coordinate system.
struct Point: Hashable {
    let x, y: Int

    static let zero = Point(0, 0)

    @inlinable
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }

    @inlinable
    static func + (_ lhs: Point, _ rhs: Point) -> Point {
        Point(lhs.x + rhs.x, lhs.y + rhs.y)
    }

    @inlinable
    static func - (_ lhs: Point, _ rhs: Point) -> Point {
        Point(lhs.x - rhs.x, lhs.y - rhs.y)
    }

    @inlinable
    static func * (_ lhs: Point, _ rhs: Int) -> Point {
        Point(lhs.x * rhs, lhs.y * rhs)
    }

    // manhattan distance
    @inlinable
    func distance(to point: Point = .zero) -> Int {
        abs(x - point.x) + abs(y - point.y)
    }

    // aka chess distance
    @inlinable
    func chebyshevDistance(to point: Point = .zero) -> Int {
        max(abs(x - point.x), abs(y - point.y))
    }
}

// MARK: - rotation
extension Point {
    func rotated(by degrees: Int) -> Point {
        switch degrees {
        case 0, 360: return self
        case 90: return Point(-y, x)
        case 180: return Point(-x, -y)
        case 270: return Point(y, -x)
        default: fatalError("invalid angle \(degrees)")
        }
    }
}

// MARK: - neighbors
extension Point {
    enum Adjacency {
        case orthogonal, diagonal, all
    }

    func neighbors(adjacency: Adjacency = .orthogonal) -> [Point] {
        let offsets: [Direction]
        switch adjacency {
        case .orthogonal: offsets = Direction.orthogonal
        case .diagonal: offsets = Direction.diagonal
        case .all: offsets = Direction.allCases
        }

        return offsets.map { self + $0.offset }
    }

    @inlinable
    func moved(to direction: Direction) -> Point {
        self + direction.offset
    }

    @inlinable
    func moved(_ direction: Direction) -> Point {
        self + direction.offset
    }

    @inlinable
    func moved(to direction: Direction, steps: Int) -> Point {
        self + direction.offset * steps
    }

    @inlinable
    func moved(_ direction: Direction, steps: Int) -> Point {
        self + direction.offset * steps
    }

    // return al points between self and `end`. Angle between self and `end` must be a multiple of 45°
    func line(to end: Point) -> [Point] {
        let dx = (end.x - x).signum()
        let dy = (end.y - y).signum()
        let range = max(abs(x - end.x), abs(y - end.y))
        return (0 ..< range).map { step in
            Point(x + dx * step, y + dy * step)
        }
    }
}

extension Point: CustomStringConvertible {
    var description: String {
        "\(x),\(y)"
    }
}

extension Point: Comparable {
    /// compare in "reading order" (top to bottom, left to right)
    static func < (lhs: Point, rhs: Point) -> Bool {
        if lhs.y != rhs.y {
            return lhs.y < rhs.y
        }
        return lhs.x < rhs.x
    }
}

