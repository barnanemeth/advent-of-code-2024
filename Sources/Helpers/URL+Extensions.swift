//
//  URL+Extensions.swift
//  advent-of-code-2024
//
//  Created by Barna Nemeth on 2024. 11. 12..
//

import Foundation

extension URL: @retroactive ExpressibleByExtendedGraphemeClusterLiteral {}
extension URL: @retroactive ExpressibleByUnicodeScalarLiteral {}
extension URL: @retroactive ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(string: value)!
    }
}
