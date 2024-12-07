//
//  Day07.swift
//
//
//  Created by Barna Nemeth on 03/12/2024.
//

import Foundation

fileprivate enum Operation: CaseIterable {
    case addition
    case multiplication
    case concatenation

    @inlinable
    func calculate(_ lhs: Int, _ rhs: Int) -> Int {
        switch self {
        case .addition: lhs + rhs
        case .multiplication: lhs * rhs
        case .concatenation: Int("\(lhs)\(rhs)")!
        }
    }

    static func generateCombinations(of length: Int, allowingConcatenation: Bool) -> [[Operation]] {
        guard length > 0 else { return [[]] }

        var cases: [Operation] = [.addition, .multiplication]
        if allowingConcatenation {
            cases.append(.concatenation)
        }

        func helper(current: [Operation], depth: Int) -> [[Operation]] {
            if depth == length {
                return [current]
            }

            var result = [[Operation]]()
            for operation in cases {
                result += helper(current: current + [operation], depth: depth + 1)
            }
            return result
        }

        return helper(current: [], depth: 0)
    }
}

fileprivate struct Equation {
    let testValue: Int
    let numbers: [Int]

    init(line: String) {
        let components = line.components(separatedBy: ": ")

        testValue = Int(components.first!)!
        numbers = components.last?.components(separatedBy: " ").compactMap { Int($0) } ?? []
    }

    func isCorrect(allowingConcatenation: Bool) -> Bool {
        let combinationMatrix = Operation.generateCombinations(of: numbers.count - 1, allowingConcatenation: allowingConcatenation)
        for combinations in combinationMatrix {
            let result = (1...numbers.count - 1).reduce(numbers[.zero]) { result, index in
                combinations[index - 1].calculate(result, numbers[index])
            }
            if result == testValue {
                return true
            }
        }
        return false
    }
}

final class Day07: DayBase {
    private let equations: [Equation]

    required init(inputContent: String) {
        equations = inputContent.trimmed().getLines().map { Equation(line: $0) }
        super.init(inputContent: inputContent)
    }
}

// MARK: - Day

extension Day07: Day {
    func partOne() async throws -> CustomStringConvertible {
        equations.filter { $0.isCorrect(allowingConcatenation: false) }.map(\.testValue).reduce(0, +)
    }
    
    func partTwo() throws -> CustomStringConvertible {
        equations.filter { $0.isCorrect(allowingConcatenation: true) }.map(\.testValue).reduce(0, +)
    }
}
