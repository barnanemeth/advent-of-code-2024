//
//  String+Extensions.swift
//  
//
//  Created by Barna Nemeth on 02/12/2024.
//

import Foundation

extension String {
    func trimmed() -> String {
        trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    subscript(bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }

    subscript(bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }

    func getLines() -> [String] {
        components(separatedBy: "\n")
    }
}
