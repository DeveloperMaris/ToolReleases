//
//  ToolReleaseDateComparisonTests.swift
//  ToolReleasesTests
//
//  Created by Maris Lagzdins on 05/06/2020.
//  Copyright © 2020 Developer Maris. All rights reserved.
//

@testable
import ToolReleases
import ToolReleasesCore
import XCTest

class ToolReleaseDateComparisonTests: XCTestCase {
    func testToolReleasedLessThanOneHourAgo() {
        // Given
        let component = DateComponents(minute: 59)
        let date = Calendar.current.date(byAdding: component, to: Date())!
        let tool = Tool.make(with: date)

        // When
        let result = ToolReleaseDateComparison.isTool(tool, releasedLessThan: 1, .hour)

        // then
        XCTAssertTrue(result)
    }

    func testToolReleasedMoreThanOneHourAgo() {
        // Given
        let component = DateComponents(minute: -61)
        let date = Calendar.current.date(byAdding: component, to: Date())!
        let tool = Tool.make(with: date)

        // When
        let result = ToolReleaseDateComparison.isTool(tool, releasedLessThan: 1, .hour)

        // then
        XCTAssertFalse(result)
    }

    func testToolReleasedLessThanOneDayAgo() {
        // Given
        let component = DateComponents(hour: -23)
        let date = Calendar.current.date(byAdding: component, to: Date())!
        let tool = Tool.make(with: date)

        // When
        let result = ToolReleaseDateComparison.isTool(tool, releasedLessThan: 1, .day)

        // then
        XCTAssertTrue(result)
    }

    func testToolReleasedMoreThanOneDayAgo() {
        // Given
        let component = DateComponents(day: -1, hour: -1)
        let date = Calendar.current.date(byAdding: component, to: Date())!
        let tool = Tool.make(with: date)

        // When
        let result = ToolReleaseDateComparison.isTool(tool, releasedLessThan: 1, .day)

        // then
        XCTAssertFalse(result)
    }

    func testToolReleasedLessThanOneDayAgoInSecondPrecision() {
        // Given
        let component = DateComponents(day: -1, second: 1)
        let date = Calendar.current.date(byAdding: component, to: Date())!
        let tool = Tool.make(with: date)

        // When
        let result = ToolReleaseDateComparison.isTool(tool, releasedLessThan: 1, .day)

        // then
        XCTAssertTrue(result)
    }

    func testToolReleasedMoreThanOneDayAgoInSecondPrecision() {
        // Given
        let component = DateComponents(day: -1, second: -1)
        let date = Calendar.current.date(byAdding: component, to: Date())!
        let tool = Tool.make(with: date)

        // When
        let result = ToolReleaseDateComparison.isTool(tool, releasedLessThan: 1, .day)

        // then
        XCTAssertFalse(result)
    }

    func testToolReleasedLessThanThreeDaysAgo() {
        // Given
        let component = DateComponents(day: -2)
        let date = Calendar.current.date(byAdding: component, to: Date())!
        let tool = Tool.make(with: date)

        // When
        let result = ToolReleaseDateComparison.isTool(tool, releasedLessThan: 3, .day)

        // then
        XCTAssertTrue(result)
    }

    func testToolReleasedMoreThanThreeDaysAgo() {
        // Given
        let component = DateComponents(day: -4)
        let date = Calendar.current.date(byAdding: component, to: Date())!
        let tool = Tool.make(with: date)

        // When
        let result = ToolReleaseDateComparison.isTool(tool, releasedLessThan: 3, .day)

        // then
        XCTAssertFalse(result)
    }

    func testToolReleasedInFuture() {
        // Given
        let component = DateComponents(month: 1)
        let date = Calendar.current.date(byAdding: component, to: Date())!
        let tool = Tool.make(with: date)

        // When
        let result = ToolReleaseDateComparison.isTool(tool, releasedLessThan: 3, .day)

        // then
        XCTAssertFalse(result)
    }

    func testToolReleasedInPast() {
        // Given
        let component = DateComponents(month: -1)
        let date = Calendar.current.date(byAdding: component, to: Date())!
        let tool = Tool.make(with: date)

        // When
        let result = ToolReleaseDateComparison.isTool(tool, releasedLessThan: 3, .day)

        // then
        XCTAssertFalse(result)
    }

    func testToolReleasedLessThanOneDayAgoInSecondPrecisionWithProvidedSinceDate() {
        // Given
        let component = DateComponents(day: -5, second: 1)
        let date = Calendar.current.date(byAdding: component, to: Date())!
        let tool = Tool.make(with: date)

        let sinceComponent = DateComponents(day: -4)
        let sinceDate = Calendar.current.date(byAdding: sinceComponent, to: Date())!

        // When
        let result = ToolReleaseDateComparison.isTool(tool, releasedLessThan: 1, .day, since: sinceDate) // Calculations must track that the difference is 59 minutes.

        // then
        XCTAssertTrue(result)
    }
}

// MARK: - Helpers
fileprivate extension Tool {
    static func make(with date: Date) -> Self {
        Tool(id: "https://developer.apple.com/news/releases/?id=1234567890a", title: "Test tool (1234567890)", date: date, url: URL(string: "www.example.com"), description: "Tool Description")
    }
}
