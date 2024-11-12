//
//  FileReader.swift
//
//  Created by Barna Nemeth on 02/12/2024.
//

import Foundation

struct FileReader {

    // MARK: Constants

    private enum Constant {
        static let filenameFormat = "day%@"
    }

    // MARK: Private properties

    private let bundle = Bundle.module
    private let fileManager = FileManager.default
}

// MARK: - InputSourceLoader

extension FileReader: InputSourceLoader {    
    func load(day: Int) async throws -> String {
        let filename = String(format: Constant.filenameFormat, stringDay(for: day))

        guard let url = bundle.url(forResource: filename, withExtension: nil) else {
            throw RunnerError.fileNotFound(filename: filename)
        }
        let data = try Data(contentsOf: url)
        guard var content = String(data: data, encoding: .utf8) else { throw RunnerError.fileConversionError }
        content.removeLast()
        return content
    }
}

// MARK: - Helpers

extension FileReader {
    private func stringDay(for day: Int) -> String {
        var characters = Array("\(day)")
        if characters.count == 1 {
            characters.insert("0", at: .zero)
        }
        return String(characters)
    }
}
