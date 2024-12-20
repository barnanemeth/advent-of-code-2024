//
//  Sequence+Extensions.swift
//  
//
//  Created by Barna Nemeth on 02/12/2024.
//

import Foundation

extension Sequence {
    func min<Value: Comparable>(of keyPath: KeyPath<Element, Value>) -> Value? {
        let element = self.min(by: { $0[keyPath: keyPath] < $1[keyPath: keyPath] })
        return element?[keyPath: keyPath]
    }

    func max<Value: Comparable>(of keyPath: KeyPath<Element, Value>) -> Value? {
        let element = self.max(by: { $0[keyPath: keyPath] < $1[keyPath: keyPath] })
        return element?[keyPath: keyPath]
    }
}

extension Array {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }

    func combinations(_ count: Int) -> [[Element]] {
        guard count > 0 else { return [[]] }
        guard count <= count else { return [] }

        if count == 1 {
            return map { [$0] }
        }

        var result: [[Element]] = []

        for (index, element) in self.enumerated() {
            let remainingElements = Array(self[(index + 1)...])
            let subcombinations = remainingElements.combinations(count - 1)
            result += subcombinations.map { [element] + $0 }
        }

        return result
    }
}
