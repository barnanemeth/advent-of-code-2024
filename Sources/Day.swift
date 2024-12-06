//
//  Day.swift
//
//  Created by Barna Nemeth on 01/12/2024.
//

import Foundation

protocol Day: AnyObject {
    func partOne() async throws -> CustomStringConvertible
    func partTwo() async throws -> CustomStringConvertible
}

open class DayBase {

    // MARK: Properties

    let inputContent: String

    // MARK: Init

    required public init(inputContent: String) {
        self.inputContent = inputContent
    }
}
