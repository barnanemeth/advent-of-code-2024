//
//  Number.swift
//  
//
//  Created by Barna Nemeth on 03/12/2024.
//

import Foundation

struct Number: Hashable {
    let value: Int
    let start: Point
    let length: Int
    let neighbors: Set<Point>

    init(value: Int, start: Point, length: Int) {
        self.value = value
        self.start = start
        self.length = length
        neighbors = Set(
            (start.y - 1 ... start.y + 1).flatMap { y in
                (start.x - 1 ... start.x + length).map { x in
                    Point(x, y)
                }
            }
        )
    }
}
