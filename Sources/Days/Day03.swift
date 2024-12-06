//
//  Day03.swift
//
//
//  Created by Barna Nemeth on 02/12/2024.
//

import Foundation

fileprivate struct Multiplication {
    let numbers: [Int]

    var result: Int { numbers.reduce(1, *) }

    init?(substring: String) {
        let components = substring
            .replacingOccurrences(of: "mul(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .components(separatedBy: ",")
        guard let firstString = components.first,
              let first = Int(firstString),
              let lastString = components.last,
              let last = Int(lastString) else { return nil }
        numbers = [first, last]
    }
}

final class Day03: DayBase {
    private let multiplications: [Multiplication]
    private let multiplicationsWithControls: [Multiplication]

    required init(inputContent: String) {
        multiplications = inputContent
            .trimmed()
            .matches(for: "mul\\([0-9]{1,3},[0-9]{1,3}\\)")
            .compactMap { Multiplication(substring: $0) }

        var isEnabled = true
        multiplicationsWithControls = inputContent
            .trimmed()
            .matches(for: #"don't\(\)|do\(\)|mul\([0-9]{1,3},[0-9]{1,3}\)"#)
            .reduce(into: [Multiplication]()) { multiplications, item in
                if isEnabled, let multiplication = Multiplication(substring: item) {
                    multiplications.append(multiplication)
                }

                switch item {
                case "don't()":
                    isEnabled = false
                case "do()":
                    isEnabled = true
                default: break
                }
            }

        super.init(inputContent: inputContent)
    }
}

// MARK: - Day

extension Day03: Day {
    func partOne() async throws -> CustomStringConvertible {
        multiplications.map(\.result).reduce(0, +)
    }

    func partTwo() throws -> CustomStringConvertible {
        multiplicationsWithControls.map(\.result).reduce(0, +)
    }
}
