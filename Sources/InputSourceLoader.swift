//
//  InputSourceLoader.swift
//  advent-of-code-2024
//
//  Created by Barna Nemeth on 2024. 11. 12..
//

import Foundation

protocol InputSourceLoader {
    func load(day: Int) async throws -> String
}
