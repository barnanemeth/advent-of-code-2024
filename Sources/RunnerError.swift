//
//  RunnerError.swift
//
//  Created by Barna Nemeth on 02/12/2024.
//

import Foundation

enum RunnerError: Error, LocalizedError {

    // MARK: Cases

    case invalidDay(day: Int)
    case instantiationError(className: String)
    case numberConversionError(number: Int)
    case fileNotFound(filename: String)
    case fileConversionError
    case invalidState

    // MARK: Properties

    var errorDescription: String? {
        switch self {
        case let .invalidDay(day): "Invalid day: \(day)"
        case let .instantiationError(className): "Instantiation error, class name: \(className)"
        case let .numberConversionError(number): "Number conversion error, number: \(number)"
        case let .fileNotFound(filename): "File not found, filename: \(filename)"
        case .fileConversionError: "File conversion error"
        case .invalidState: "Invalid state"
        }
    }
}
