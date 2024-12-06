//
//  Day05.swift
//
//
//  Created by Barna Nemeth on 03/12/2024.
//

import Foundation

fileprivate struct PageOrderingRule: Hashable, Equatable {
    let first: Int
    let second: Int

    init(line: String) {
        let components = line.components(separatedBy: "|")
        first = Int(components.first!)!
        second = Int(components.last!)!
    }

    init(first: Int, second: Int) {
        self.first = first
        self.second = second
    }

    func isUpdateCorrect(update: Update) -> Bool {
        update.isCorrect(using: self)
    }
}

fileprivate struct Update {
    var numbers: [Int]

    init(line: String) {
        numbers = line.components(separatedBy: ",").compactMap { Int($0) }
    }

    func isCorrect(using rule: PageOrderingRule) -> Bool {
        guard let firstIndex = numbers.firstIndex(of: rule.first),
              let secondIndex = numbers.firstIndex(of: rule.second) else { return false }
        return firstIndex < secondIndex
    }

    mutating func corrected(using rule: PageOrderingRule) {
        guard let firstIndex = numbers.firstIndex(of: rule.first),
              let secondIndex = numbers.firstIndex(of: rule.second),
              !isCorrect(using: rule)  else { return }
        numbers.swapAt(firstIndex, secondIndex)
    }
}

final class Day05: DayBase {
    private let rules: [PageOrderingRule]
    private let updates: [Update]

    required init(inputContent: String) {
        let sections = inputContent.trimmed().components(separatedBy: "\n\n")

        rules = sections.first!.getLines().map { PageOrderingRule(line: $0) }
        updates = sections.last!.getLines().map { Update(line: $0) }

        super.init(inputContent: inputContent)
    }

    private func sumOfMiddlePages(updates: [Update]) -> Int {
        updates
            .filter { update in
                for rule in rules.filter({ [$0.first, $0.second].allSatisfy({ update.numbers.contains($0) }) }) {
                    if !update.isCorrect(using: rule) { return false }
                }
                return true
            }
            .map { $0.numbers[$0.numbers.count / 2] }
            .reduce(0, +)
    }
}

// MARK: - Day

extension Day05: Day {
    func partOne() async throws -> CustomStringConvertible {
        sumOfMiddlePages(updates: updates)
    }
    
    func partTwo() throws -> CustomStringConvertible {
        updates
            .filter { update in
                for rule in rules.filter({ [$0.first, $0.second].allSatisfy({ update.numbers.contains($0) }) }) {
                    if !update.isCorrect(using: rule) { return true }
                }
                return false
            }
            .reduce(into: 0) { sum, incorrect in
                let sorted = incorrect.numbers.sorted { first, second in
                    rules.contains(PageOrderingRule(first: first, second: second))
                }
                sum += sorted[sorted.count / 2]
            }
    }
}
