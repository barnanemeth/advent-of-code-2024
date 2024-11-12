//
//  Runner.swift
//
//  Created by Barna Nemeth on 01/12/2024.
//

import Foundation
import ArgumentParser

@main
final class Runner: AsyncParsableCommand {

    // MARK: Constants

    private enum Constant {
        static let dayRange = (1...24)
        static let defaultMonth = 12
        static let defaultDay = 1
        static let dayClassFormat = "Day%@"
        static let introLogFormat = "🎄🎄🎄 Advent of Code \(GlobalConstant.year) 🎄🎄🎄\n\n--- DAY %@ ---"
        static let infoLogFormat = "Runnable parts: %@\nUse example input: %@"
        static let solutionLogFormat = "The solution of Day %d Part %d is: %d"
    }

    // MARK: Private properties

    @Option(name: .long, help: "Day number")
    private var day: Int? = nil
    @Option(name: .customLong("session-token"), help: "Session token")
    private var sessionToken: String? = nil
    @Argument(help: "Runnable parts")
    private var parts: [Part]
    @Flag(name: .customLong("use-example-input"), help: "Should use example input") 
    private var shouldUseExampleInput: Bool = false

    private var calendar = Calendar.current
}

// MARK: - Public methods

extension Runner {
    func run() async throws {
        try checkDayIfNeeded()
        let day = getCurrentDayNumber()

        print(String(format: Constant.introLogFormat, try getTwoDigitString(for: day)))
        print(String(format: Constant.infoLogFormat, getRunnablePartsString(), shouldUseExampleInput.description))
        print("\n")

        try await runDay(with: day)
    }
}

// MARK: - Private methods

extension Runner {
    private func checkDayIfNeeded() throws {
        guard let day else { return }
        if !(Constant.dayRange ~= day) {
            throw RunnerError.invalidDay(day: day)
        }
    }

    private func getCurrentDayNumber() -> Int {
        if let day {
            return day
        }

        let components = calendar.dateComponents([.month, .day], from: Date.now)
        guard components.month == Constant.defaultMonth,
              let day = components.day,
              day < Constant.dayRange.upperBound else { return Constant.defaultDay }

        return day
    }

    private func getInstanceForDayNumber(_ dayNumber: Int) async throws -> any Day {
        let selfDescription = String(describing: Self.self)
        let selfReflection = String(reflecting: Self.self)

        let dayClassName = String(format: Constant.dayClassFormat, try getTwoDigitString(for: dayNumber))
        let className = selfReflection.replacingOccurrences(of: selfDescription, with: dayClassName)

        guard let instanceType = NSClassFromString(className) as? DayBase.Type else {
            throw RunnerError.instantiationError(className: className)
        }

        let inputSourceLoader: InputSourceLoader = if shouldUseExampleInput {
            FileReader()
        } else {
            Downloader(sessionToken: sessionToken)
        }
        let content = try await inputSourceLoader.load(day: dayNumber)

        guard let instance = instanceType.init(inputContent: content) as? Day else {
            throw RunnerError.instantiationError(className: className)
        }
        return instance
    }

    private func getTwoDigitString(for number: Int) throws -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumIntegerDigits = 2
        guard let string = numberFormatter.string(from: NSNumber(value: number)) else {
            throw RunnerError.numberConversionError(number: number)
        }
        return string
    }

    private func getRunnablePartsString() -> String {
        parts.map { $0.rawValue }.joined(separator: ",")
    }

    private func runDay(with number: Int) async throws {
        let dayInstance = try await getInstanceForDayNumber(number)

        if parts.contains(.one) {
            let solution = try dayInstance.partOne()
            print(String(format: Constant.solutionLogFormat, number, 1, solution))
        }
        if parts.contains(.two) {
            let solution = try dayInstance.partTwo()
            print(String(format: Constant.solutionLogFormat, number, 2, solution))
        }
    }
}
