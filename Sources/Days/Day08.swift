//
//  Day08.swift
//
//
//  Created by Barna Nemeth on 03/12/2024.
//

import Foundation

fileprivate enum MapItem: Equatable {
    case empty
    case antenna(Character)
    case antinode

    var anetnnaCharacter: Character? {
        switch self {
        case let .antenna(character): character
        default: nil
        }
    }

    init(character: Character) {
        switch character {
        case ".": self = .empty
        default:
            guard character.isLetter || character.isNumber else { fatalError() }
            self = .antenna(character)
        }
    }
}

final class Day08: DayBase {
    private let map: [Point: MapItem]

    required init(inputContent: String) {
        let points = inputContent.trimmed().getLines().enumerated().flatMap { y, line in
            line.enumerated().map { x, character in
                (Point(x, y), MapItem(character: character))
            }
        }
        map = Dictionary(points, uniquingKeysWith: { _, item in item })

        super.init(inputContent: inputContent)
    }

    private func searchingAntinodes(withTFrequencyAntennas: Bool) -> [Point: MapItem] {
        var map = map
        let antennas = map.filter { $0.value != .empty }
        Set(antennas.compactMap(\.value.anetnnaCharacter)).forEach { character in
            let matching = antennas.filter { $0.value.anetnnaCharacter == character }.map(\.key)
            matching.combinations(2).forEach { combination in
                let first = combination.first!
                let last = combination.last!
                let diff = first - last

                if withTFrequencyAntennas {
                    var point = first
                    while map[point] != nil {
                        map[point] = .antinode
                        point = point + diff
                    }
                    point = last
                    while map[point] != nil {
                        map[point] = .antinode
                        point = point - diff
                    }
                } else {
                    let newFirst = first + diff
                    if map[newFirst] != nil {
                        map[newFirst] = .antinode
                    }

                    let newLast = last - diff
                    if map[newLast] != nil {
                        map[newLast] = .antinode
                    }
                }
            }
        }
        return map
    }
}

// MARK: - Day

extension Day08: Day {
    func partOne() async throws -> CustomStringConvertible {
        searchingAntinodes(withTFrequencyAntennas: false).filter { $0.value == .antinode }.count
    }
    
    func partTwo() throws -> CustomStringConvertible {
        searchingAntinodes(withTFrequencyAntennas: true).filter { $0.value == .antinode }.count
    }
}
