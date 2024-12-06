//
//  Day01.swift
//
//
//  Created by Barna Nemeth on 02/12/2024.
//

import Foundation

fileprivate struct Pair {
    let left: Int
    let right: Int

    var distance: Int { max(left, right) - min(left, right) }
}

final class Day01: DayBase {
    private let leftColum: [Int]
    private let rightColumn: [Int]
    private let pairs: [Pair]

    required init(inputContent: String) {
        let columns = inputContent.trimmed().getLines().reduce(into: (left: [Int](), right: [Int]())) { columns, line in
            let components = line.components(separatedBy: "   ")
            columns.left.append(Int(components[0])!)
            columns.right.append(Int(components[1])!)
        }

        leftColum = columns.left
        rightColumn = columns.right

        pairs = zip(columns.left.sorted(by: <), columns.right.sorted(by: <)).map { Pair(left: $0, right: $1) }

        super.init(inputContent: inputContent)
    }
}

// MARK: - Day

extension Day01: Day {
    func partOne() async throws -> CustomStringConvertible {
        pairs.map(\.distance).reduce(0, +)
    }

    func partTwo() throws -> CustomStringConvertible {
        leftColum.reduce(0) { sum, item in
            sum + rightColumn.count(where: { $0 == item }) * item
        }
    }
}
