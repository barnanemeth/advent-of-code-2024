//
//  Part.swift
//
//  Created by Barna Nemeth on 02/12/2024.
//

import Foundation
import ArgumentParser

enum Part: String {
    case one
    case two
}

// MARK: - ExpressibleByArgument

extension Part: ExpressibleByArgument {
    init?(argument: String) {
        self.init(rawValue: argument)
    }
}
