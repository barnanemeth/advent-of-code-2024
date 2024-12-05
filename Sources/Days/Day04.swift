//
//  Day04.swift
//
//
//  Created by Barna Nemeth on 03/12/2024.
//

import Foundation

final class Day04: DayBase {
    private let matrix: [Point: Character]

    required init(inputContent: String) {
        let coordinates = inputContent.trimmed().getLines().enumerated().flatMap { y, line in
                line.enumerated().map { x, ch in
                    let p = Point(x, y)
                    return (p, ch)
                }
            }
        matrix = Dictionary(coordinates, uniquingKeysWith: { _, new in new } )

        super.init(inputContent: inputContent)
    }

    private func findMatching(at p: Point) -> Int {
        guard ["X", "S"].contains(matrix[p]) else { return 0 }

        let sets = Direction.allCases.map { dir in
            (0...3).map { steps in
                p.moved(to: dir, steps: steps)
            }
        }

        let search: [Character] = ["X", "M", "A", "S"]
        let searchRev = Array(search.reversed())

        return sets
            .filter { set in
                let cmp = set.map {
                    matrix[$0, default: " "]
                }
                return cmp == search || cmp == searchRev
            }
            .count
    }

    private func findMatchingTwo(at p: Point) -> Bool {
        guard matrix[p] == "A" else { return false }

         let sets = [
             [p.moved(to: .nw), p, p.moved(to: .se)],
             [p.moved(to: .sw), p, p.moved(to: .ne)]
         ]

         let search: [Character] = ["M", "A", "S"]
         let searchRev = Array(search.reversed())

         return sets.allSatisfy { set in
             let cmp = set.map {
                 matrix[$0, default: " "]
             }
             return cmp == search || cmp == searchRev
         }
    }
}

// MARK: - Day

extension Day04: Day {
    func partOne() throws -> CustomStringConvertible {
        matrix.keys
            .map { findMatching(at: $0) }
            .reduce(0, +) / 2
    }
    
    func partTwo() throws -> CustomStringConvertible {
        matrix.keys
            .filter { findMatchingTwo(at: $0) }
            .count
    }
}
