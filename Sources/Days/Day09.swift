//
//  Day09.swift
//
//
//  Created by Barna Nemeth on 03/12/2024.
//

import Foundation

fileprivate enum DiskItem: Equatable, CustomStringConvertible {
    case block(id: Int)
    case space

    var id: Int? {
        switch self {
        case let .block(id): id
        default: nil
        }
    }

    var description: String {
        switch self {
        case let .block(id): id.description
        case .space: "."
        }
    }
}

final class Day09: DayBase {
    private var diskMap: [DiskItem]
    private var spacesSum: Int

    private var isFinished: Bool {
        diskMap[diskMap.count - spacesSum..<diskMap.count].allSatisfy { $0 == .space }
    }
    private var checksum: Int {
        diskMap.enumerated().reduce(0) { sum, item in
            guard item.element != .space else { return sum }
            return sum + item.offset * item.element.id!
        }
    }

    required init(inputContent: String) {
        var id = 0
        var diskMap = [DiskItem]()
        var spacesSum = 0
        let numberArray = Array(inputContent)
        for (offset, length) in numberArray.compactMap({ Int("\($0)") }).enumerated() {
            if offset % 2 == .zero {
                diskMap.append(contentsOf: [DiskItem](repeating: .block(id: id), count: length))
                id += 1
            } else {
                diskMap.append(contentsOf: [DiskItem](repeating: .space, count: length))
                spacesSum += length
            }
        }
        self.diskMap = diskMap
        self.spacesSum = spacesSum

        super.init(inputContent: inputContent)
    }
}

// MARK: - Day

extension Day09: Day {
    func partOne() async throws -> CustomStringConvertible {
        while !isFinished {
            guard let lastBlockIndex = diskMap.lastIndex(where: { $0.id != nil }),
                  let firstSpaceIndex = diskMap.firstIndex(where: { $0 == .space }) else { continue }
            diskMap[firstSpaceIndex] = .block(id: diskMap[lastBlockIndex].id!)
            diskMap[lastBlockIndex] = .space
        }
        return checksum
    }
    
    func partTwo() throws -> CustomStringConvertible {
        var grouped = diskMap.reduce(into: [[DiskItem]]()) { grouped, diskItem in
            if grouped.last?.last == diskItem {
                grouped[grouped.count - 1].append(diskItem)
            } else {
                grouped.append([diskItem])
            }
        }
        var isDefragmented = false
        var currentFileID = diskMap.compactMap { $0.id }.max()!
        while !isDefragmented {
            let blockGroupIndex = grouped.lastIndex(where: { group in
                guard group.first?.id <= currentFileID else { return false }
                return grouped.enumerated().contains(where: { $1.first == .space && $1.count >= group.count && $0 < grouped.firstIndex(of: group)! })
            })
            if let blockGroupIndex,
               let spaceGroupIndex = grouped.firstIndex(where: { $0.first == .space && $0.count >= grouped[blockGroupIndex].count }),
               spaceGroupIndex < blockGroupIndex {
                currentFileID = grouped[blockGroupIndex].first!.id! - 1
                let diff = grouped[spaceGroupIndex].count - grouped[blockGroupIndex].count
                grouped[spaceGroupIndex] = grouped[blockGroupIndex]
                grouped[blockGroupIndex] = [DiskItem](repeating: .space, count: grouped[blockGroupIndex].count)
                grouped.insert([DiskItem](repeating: .space, count: diff), at: spaceGroupIndex + 1)
                grouped.removeAll(where: { $0.isEmpty })
                grouped = grouped.flatMap { $0 }.reduce(into: [[DiskItem]]()) { grouped, diskItem in
                    if grouped.last?.last == diskItem {
                        grouped[grouped.count - 1].append(diskItem)
                    } else {
                        grouped.append([diskItem])
                    }
                }
            } else {
                isDefragmented = true
            }
        }
        return grouped.flatMap { $0 }.enumerated().reduce(0) { sum, item in
            guard item.element != .space else { return sum }
            return sum + item.offset * item.element.id!
        }
    }
}

fileprivate extension Optional<Int> {
    static func <= (_ lhs: Self, _ rhs: Self) -> Bool {
        guard let lhs, let rhs else { return false }
        return lhs <= rhs
    }
}
