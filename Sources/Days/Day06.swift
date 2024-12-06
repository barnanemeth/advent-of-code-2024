//
//  Day06.swift
//
//
//  Created by Barna Nemeth on 03/12/2024.
//

import Foundation

fileprivate struct Map {
    var map: [Point: MapPosition]
    let maxX: Int
    let maxY: Int
    var obstaclesSeen = 0

    var currentPosition: (point: Point, direction: Direction) {
        for (key, position) in map {
            if case let .currentLocation(direction) = position {
                return (key, direction)
            }
        }
        fatalError()
    }
    var canMove: Bool {
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
    var isLoopDetected: Bool {
        obstaclesSeen == 2
    }

    mutating func moveOneStep() {
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
    private var map: Map

    required init(inputContent: String) {
        let points = inputContent.trimmed().getLines().enumerated().flatMap { y, line in
            line.enumerated().map { x, character in
                (Point(x, y), MapPosition(character: character))
            }
        }

        let innerMap = Dictionary(points, uniquingKeysWith: { _, item in item })
        map = Map(
            map: innerMap,
            maxX: innerMap.max(by: { $0.key.x < $1.key.x })?.key.x ?? .zero,
            maxY: innerMap.max(by: { $0.key.y < $1.key.y })?.key.y ?? .zero
        )

        super.init(inputContent: inputContent)
    }
}

// MARK: - Day

extension Day06: Day {
    func partOne() async throws -> CustomStringConvertible {
        while map.canMove {
            map.moveOneStep()
        }
        return map.map.count(where: { $0.value == .seen }) + 1
    }
    
    func partTwo() async throws -> CustomStringConvertible {
        var possibleObstaclePositions = (0...map.maxX).reduce(into: [Point]()) { points, x in
            (0...map.maxY).forEach { points.append(Point(x, $0)) }
        }
        possibleObstaclePositions.removeAll(where: { map.map[$0] == .item })
        possibleObstaclePositions.removeAll(where: { map.map[$0]!.isCurrent })

        return await withTaskGroup(of: (Point, Bool).self) { taskGroup in
            possibleObstaclePositions.forEach { point in
                taskGroup.addTask {
                    defer { print(point) }
                    var map = Map(map: self.map.map, maxX: self.map.maxX, maxY: self.map.maxY)
                    map.map[point] = .obstacle
                    while map.canMove && !map.isLoopDetected {
                        map.moveOneStep()
                        if map.isLoopDetected {
                            return (point, true)
                        }
                    }
                    return (point, false)
                }
            }

            return await taskGroup.reduce(0) { sum, taskGroup in sum + (taskGroup.1 ? 1 : 0)  }
        }
    }
}
