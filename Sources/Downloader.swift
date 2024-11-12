//
//  Downloader.swift
//  advent-of-code-2024
//
//  Created by Barna Nemeth on 2024. 11. 12..
//

import Foundation

struct Downloader {

    // MARK: Inner types

    enum `Error`: Swift.Error, LocalizedError {
        case missingSessionToken
        case invalidSessionToken
        case notFound

        var errorDescription: String? {
            switch self {
            case .missingSessionToken: "Missing session token"
            case .invalidSessionToken: "Invalid session token"
            case .notFound: "Resource not found"
            }
        }
    }

    // MARK: Constants

    private enum Constant {
        static let baseURL: URL = "https://adventofcode.com"
        static let daySubpath = "day"
        static let inputSubpath = "input"
        static let cookieHeaderKey = "Cookie"
        static let cookieSessionFormat = "session=%@"
        static let userDefaultsKeyFormat = "input_%d_%d"
    }

    // MARK: Private properties

    private let session = URLSession.shared
    private let userDefaults = UserDefaults.standard
    private let sessionToken: String?

    // MARK: Init

    init(sessionToken: String?) {
        self.sessionToken = sessionToken
    }
}

// MARK: - InputSourceLoader

extension Downloader: InputSourceLoader {
    func load(day: Int) async throws -> String {
        if let input = getCachedIfExists(day: day) {
            return input
        } else {
            let input = try await downloadInput(day: day)
            saveCache(input, for: day)
            return input
        }
    }
}

// MARK: - Helpers

extension Downloader {
    private func buildRequest(for day: Int) throws -> URLRequest {
        guard let sessionToken else { throw Error.missingSessionToken }

        let url = Constant.baseURL
            .appending(path: GlobalConstant.year.description)
            .appending(path: Constant.daySubpath)
            .appending(path: day.description)
            .appending(path: Constant.inputSubpath)
        var request = URLRequest(url: url)
        request.setValue(
            String(format: Constant.cookieSessionFormat, sessionToken),
            forHTTPHeaderField: Constant.cookieHeaderKey
        )
        return request
    }

    private func validateResponse(_ response: URLResponse) throws {
        guard let httpUrlResponse = response as? HTTPURLResponse else { throw URLError(.cannotParseResponse) }
        if 200..<300 ~= httpUrlResponse.statusCode   {
            return
        }
        if httpUrlResponse.statusCode == 404 {
            throw Error.notFound
        }
        throw Error.invalidSessionToken
    }

    private func downloadInput(day: Int) async throws -> String {
        let (data, response) = try await session.data(for: buildRequest(for: day))
        try validateResponse(response)
        guard let string = String(data: data, encoding: .utf8) else { throw URLError(.cannotParseResponse) }
        return string
    }

    private func getCachedIfExists(day: Int) -> String? {
        userDefaults.string(forKey: String(format: Constant.userDefaultsKeyFormat, GlobalConstant.year, day))
    }

    private func saveCache(_ input: String, for day: Int) {
        userDefaults.set(input, forKey: String(format: Constant.userDefaultsKeyFormat, GlobalConstant.year, day))
    }
}
