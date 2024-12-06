//
//  Day02.swift
//
//
//  Created by Barna Nemeth on 02/12/2024.
//

import Foundation

fileprivate struct Report {
    var levels: [Int]

    init(line: String) {
        levels = line.components(separatedBy: " ").compactMap { Int($0) }
    }

    var isSafe: Bool { isLevelsSafe(levels) }

    var isSafeWithRemovingOneLevel: Bool {
        for offset in levels.indices {
            var levels = levels
            levels.remove(at: offset)
            if isLevelsSafe(levels) {
                return true
            }
        }

        return false
    }

    func isLevelsSafe(_ levels: [Int]) -> Bool {
        let isSorted = levels == levels.sorted(by: <) || levels == levels.sorted(by: >)
        if isSorted {
            for (offset, level) in levels.enumerated() {
                guard offset != .zero else { continue }
                let previous = levels[offset - 1]
                if 1...3 ~= abs(level - previous) {
                    continue
                } else {
                    return false
                }
            }
        } else {
            return false
        }
        return true
    }
}

final class Day02: DayBase {
    private let reports: [Report]

    required init(inputContent: String) {
        reports = inputContent.trimmed().getLines().map { Report(line: $0) }

        super.init(inputContent: inputContent)
    }
}

// MARK: - Day

extension Day02: Day {
    func partOne() async throws -> CustomStringConvertible {
        reports.reduce(0) { $1.isSafe ? $0 + 1 : $0 }
    }

    func partTwo() throws -> CustomStringConvertible {
        reports.reduce(0) { $1.isSafeWithRemovingOneLevel ? $0 + 1 : $0 }
    }
}
