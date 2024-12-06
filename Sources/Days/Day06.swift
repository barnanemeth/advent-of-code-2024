//
//  Day06.swift
//
//
//  Created by Barna Nemeth on 03/12/2024.
//

import Foundation

fileprivate enum MapPosition: Equatable {
    case currentLocation(direction: Direction)
    case empty
    case item
    case seen
    case obstacle

    var isCurrent: Bool {
        switch self {
        case .currentLocation: true
        default: false
        }
    }

    var currentLocationDirection: Direction? {
        guard case let .currentLocation(direction) = self else { return nil }
        return direction
    }

    init(character: Character) {
        switch character {
        case ".": self = .empty
        case "#": self = .item
        case "^": self = .currentLocation(direction: .up)
        case ">": self = .currentLocation(direction: .right)
        case "<": self = .currentLocation(direction: .left)
        case "v": self = .currentLocation(direction: .down)
        default: fatalError()
        }
    }

    func rotated() -> MapPosition {
        guard case let .currentLocation(direction) = self else { fatalError() }
        switch direction {
        case .up: return .currentLocation(direction: .right)
        case .right: return .currentLocation(direction: .down)
        case .down: return .currentLocation(direction: .left)
        case .left: return .currentLocation(direction: .up)
        default: fatalError()
        }
    }
}

final class Day06: DayBase {
    private var map: [Point: MapPosition]
    private let maxX: Int
    private let maxY: Int
    private var obstaclesSeen = 0

    private var currentPosition: (point: Point, direction: Direction) {
        for (key, position) in map {
            if case let .currentLocation(direction) = position {
                return (key, direction)
            }
        }
        fatalError()
    }
    private var canMove: Bool {
        let current = currentPosition
        return switch current.direction {
        case .up:
            current.point.y != .zero
        case .right:
            current.point.x != maxX
        case .down:
            current.point.y != maxY
        case .left:
            current.point.x != .zero
        default:
            fatalError()
        }
    }
    private var isLoopDetected: Bool {
        obstaclesSeen == 2
    }

    required init(inputContent: String) {
        let points = inputContent.trimmed().getLines().enumerated().flatMap { y, line in
            line.enumerated().map { x, character in
                (Point(x, y), MapPosition(character: character))
            }
        }
        map = Dictionary(points, uniquingKeysWith: { _, item in item })
        maxX = map.max(by: { $0.key.x < $1.key.x })?.key.x ?? .zero
        maxY = map.max(by: { $0.key.y < $1.key.y })?.key.y ?? .zero

        super.init(inputContent: inputContent)
    }

    private func moveOneStep() {
        let current = currentPosition
        let proposedNew = current.point.moved(to: current.direction)
        let mapItem = map[proposedNew]

        if mapItem == .item || mapItem == .obstacle {
            map[current.point] = map[current.point]?.rotated()
            if mapItem == .obstacle {
                obstaclesSeen += 1
                return
            }
        } else if mapItem == .empty || mapItem == .seen {
            map[proposedNew] = .currentLocation(direction: current.direction)
            map[current.point] = .seen
        }
    }
}

// MARK: - Day

extension Day06: Day {
    func partOne() async throws -> CustomStringConvertible {
        while canMove {
            moveOneStep()
        }
        return map.count(where: { $0.value == .seen }) + 1
    }
    
    func partTwo() throws -> CustomStringConvertible {
        var possibleObstaclePositions = (0...maxX).reduce(into: [Point]()) { points, x in
            (0...maxY).forEach { points.append(Point(x, $0)) }
        }
        possibleObstaclePositions.removeAll(where: { map[$0] == .item })
        possibleObstaclePositions.removeAll(where: { map[$0]!.isCurrent })

        let originalMap = map
        var correctObstaclePositions = [Point]()
        for position in possibleObstaclePositions {
            var newMap = originalMap
            newMap[position] = .obstacle
            map = newMap
            obstaclesSeen = 0
            while canMove && !isLoopDetected {
                moveOneStep()
                if isLoopDetected {
                    correctObstaclePositions.append(position)
                }
            }
        }

        return correctObstaclePositions.count
    }
}
